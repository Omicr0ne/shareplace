import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:supabase/supabase.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    _printUsageAndExit(64);
  }

  final command = arguments.first;
  final envFilePath = _argValue(arguments, '--env') ?? '.env';
  final env = _loadDotenv(envFilePath);

  final supabaseUrl = env['SUPABASE_URL'];
  final apiKey = env['SUPABASE_SERVICE_ROLE_KEY'] ?? env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseUrl.isEmpty) {
    stderr.writeln('Missing SUPABASE_URL in $envFilePath.');
    exit(64);
  }
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln(
      'Missing SUPABASE_SERVICE_ROLE_KEY or SUPABASE_ANON_KEY in $envFilePath.',
    );
    exit(64);
  }

  final client = SupabaseClient(supabaseUrl, apiKey);

  switch (command) {
    case 'seed':
      await _seed(client);
    case 'reset':
      await _reset(client);
    default:
      _printUsageAndExit(64);
  }

  // Ensure the CLI exits even if a package keeps background timers alive.
  exit(0);
}

Future<void> _seed(SupabaseClient client) async {
  stdout.writeln('Seeding Supabase...');

  await client.from('tags').upsert(_seedTags, onConflict: 'id');
  await client.from('profiles').upsert(_seedProfiles, onConflict: 'id');
  await client.from('deals').upsert(_seedDeals, onConflict: 'id');
  await client
      .from('deal_tags')
      .upsert(
        _seedDealTags,
        onConflict: 'deal_id,tag_id',
      );
  await _seedProfileImages(client);
  await _seedDealImages(client);
  await client
      .from('deal_applications')
      .upsert(_seedApplications, onConflict: 'id');
  await _upsertReportsWithFallback(client);

  stdout.writeln('Seed completed.');
}

Future<void> _reset(SupabaseClient client) async {
  stdout.writeln('Resetting seeded data from Supabase...');

  await client.from('reports').delete().inFilter('id', _seedReportIds);
  await client
      .from('deal_applications')
      .delete()
      .inFilter('id', _seedApplicationIds);
  await client.from('deal_images').delete().inFilter('deal_id', _seedDealIds);
  await client.from('deal_tags').delete().inFilter('deal_id', _seedDealIds);
  await client
      .from('profiles')
      .update({'profile_picture_url': null})
      .inFilter('id', _seedProfileIds);
  await client.from('deals').delete().inFilter('id', _seedDealIds);
  await client.from('profiles').delete().inFilter('id', _seedProfileIds);
  await _removeSeedStorageFiles(client);

  stdout.writeln('Reset completed.');
}

Map<String, String> _loadDotenv(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Env file not found: $path');
    exit(66);
  }

  final values = <String, String>{};
  for (final rawLine in file.readAsLinesSync()) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) {
      continue;
    }
    final separatorIndex = line.indexOf('=');
    if (separatorIndex <= 0) {
      continue;
    }
    final key = line.substring(0, separatorIndex).trim();
    var value = line.substring(separatorIndex + 1).trim();
    if ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      value = value.substring(1, value.length - 1);
    }
    values[key] = value;
  }
  return values;
}

String? _argValue(List<String> args, String name) {
  for (final arg in args) {
    if (arg.startsWith('$name=')) {
      return arg.substring(name.length + 1);
    }
  }
  return null;
}

Never _printUsageAndExit(int code) {
  stderr
    ..writeln('Usage:')
    ..writeln('  dart run tool/seed/supabase_seed.dart seed [--env=.env]')
    ..writeln('  dart run tool/seed/supabase_seed.dart reset [--env=.env]');
  exit(code);
}

Future<void> _upsertReportsWithFallback(SupabaseClient client) async {
  for (final baseReport in _seedReports) {
    final payloads = <Map<String, Object?>>[
      {...baseReport, 'state': 'pending'},
      {...baseReport, 'state': 'open'},
      {...baseReport, 'state': 'submitted'},
      {...baseReport, 'state': 'new'},
      baseReport,
    ];

    PostgrestException? lastError;
    var inserted = false;
    for (final payload in payloads) {
      try {
        await client.from('reports').upsert([payload], onConflict: 'id');
        inserted = true;
        break;
      } on PostgrestException catch (error) {
        lastError = error;
      }
    }

    if (!inserted) {
      if (lastError != null) {
        throw Exception(
          'Unable to upsert report with fallback states: ${lastError.message}',
        );
      }
      throw StateError('Unable to upsert report with fallback states.');
    }
  }
}

Future<void> _seedProfileImages(SupabaseClient client) async {
  for (final profileId in _seedProfileIds) {
    final path = _profileImagePathByProfileId[profileId]!;
    final bytes = _profileImageBytesByProfileId[profileId]!;
    await client.storage
        .from(_profileImagesBucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/png',
            upsert: true,
          ),
        );
    final publicUrl = client.storage
        .from(_profileImagesBucket)
        .getPublicUrl(
          path,
        );
    await client
        .from('profiles')
        .update({'profile_picture_url': publicUrl})
        .eq(
          'id',
          profileId,
        );
  }
}

Future<void> _seedDealImages(SupabaseClient client) async {
  await client.from('deal_images').delete().inFilter('deal_id', _seedDealIds);

  final uploaded = <_UploadedDealSeedImage>[];
  for (final image in _seedDealImageFixtures) {
    await client.storage
        .from(_dealImagesBucket)
        .uploadBinary(
          image.storagePath,
          image.bytes,
          fileOptions: const FileOptions(
            contentType: 'image/png',
            upsert: true,
          ),
        );
    uploaded.add(
      _UploadedDealSeedImage(
        id: image.id,
        dealId: image.dealId,
        position: image.position,
        path: image.storagePath,
        publicUrl: client.storage
            .from(_dealImagesBucket)
            .getPublicUrl(
              image.storagePath,
            ),
      ),
    );
  }

  PostgrestException? lastError;
  final payloadVariants = <List<Map<String, Object?>>>[
    uploaded
        .map(
          (item) => {
            'id': item.id,
            'deal_id': item.dealId,
            'url': item.publicUrl,
            'storage_path': item.path,
            'position': item.position,
          },
        )
        .toList(growable: false),
    uploaded
        .map(
          (item) => {
            'id': item.id,
            'deal_id': item.dealId,
            'url': item.publicUrl,
            'storage_path': item.path,
            'sort_order': item.position,
          },
        )
        .toList(growable: false),
    uploaded
        .map(
          (item) => {
            'id': item.id,
            'deal_id': item.dealId,
            'image_url': item.publicUrl,
            'storage_path': item.path,
            'position': item.position,
          },
        )
        .toList(growable: false),
    uploaded
        .map(
          (item) => {
            'id': item.id,
            'deal_id': item.dealId,
            'url': item.publicUrl,
            'position': item.position,
          },
        )
        .toList(growable: false),
    uploaded
        .map(
          (item) => {
            'id': item.id,
            'deal_id': item.dealId,
            'image_url': item.publicUrl,
            'position': item.position,
          },
        )
        .toList(growable: false),
    uploaded
        .map(
          (item) => {
            'deal_id': item.dealId,
            'url': item.publicUrl,
            'position': item.position,
          },
        )
        .toList(growable: false),
    uploaded
        .map(
          (item) => {
            'deal_id': item.dealId,
            'image_url': item.publicUrl,
            'position': item.position,
          },
        )
        .toList(growable: false),
    uploaded
        .map(
          (item) => {
            'deal_id': item.dealId,
            'url': item.publicUrl,
            'storage_path': item.path,
            'position': item.position,
          },
        )
        .toList(growable: false),
    uploaded
        .map(
          (item) => {
            'deal_id': item.dealId,
            'url': item.publicUrl,
          },
        )
        .toList(growable: false),
    uploaded
        .map(
          (item) => {
            'deal_id': item.dealId,
            'image_url': item.publicUrl,
          },
        )
        .toList(growable: false),
  ];

  for (final payload in payloadVariants) {
    try {
      await client.from('deal_images').insert(payload);
      return;
    } on PostgrestException catch (error) {
      lastError = error;
    }
  }

  if (lastError != null) {
    throw Exception('Unable to seed deal images: ${lastError.message}');
  }
  throw StateError('Unable to seed deal images.');
}

Future<void> _removeSeedStorageFiles(SupabaseClient client) async {
  try {
    await client.storage
        .from(_profileImagesBucket)
        .remove(
          _profileImagePathByProfileId.values.toList(),
        );
  } on Object {
    // Ignore if files do not exist.
  }

  try {
    await client.storage
        .from(_dealImagesBucket)
        .remove(
          _seedDealImageFixtures.map((image) => image.storagePath).toList(),
        );
  } on Object {
    // Ignore if files do not exist.
  }
}

const _seedProfiles = <Map<String, Object?>>[
  {
    'id': '11111111-1111-1111-1111-111111111111',
    'first_name': 'Lina',
    'last_name': 'Martin',
    'postal_code': '75011',
    'description': 'Donne meubles et électroménager.',
    'student_verification_status': 'none',
  },
  {
    'id': '22222222-2222-2222-2222-222222222222',
    'first_name': 'Yanis',
    'last_name': 'Durand',
    'postal_code': '69003',
    'description': 'Cherche des équipements pour studio.',
    'student_verification_status': 'none',
  },
  {
    'id': '33333333-3333-3333-3333-333333333333',
    'first_name': 'Sarah',
    'last_name': 'Benoit',
    'postal_code': '31000',
    'description': 'Intéressée par les dons alimentaires.',
    'student_verification_status': 'none',
  },
];

const _seedDeals = <Map<String, Object?>>[
  {
    'id': 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    'seller_profile_id': '11111111-1111-1111-1111-111111111111',
    'title': 'Canapé convertible',
    'description': 'Canapé 2 places en bon état, à récupérer rapidement.',
    'postal_code': '75011',
    'max_winner_count': 1,
    'state': 'open',
    'is_food_supply': false,
  },
  {
    'id': 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
    'seller_profile_id': '11111111-1111-1111-1111-111111111111',
    'title': 'Pack de conserves',
    'description': 'Lot alimentaire non entamé, date longue conservation.',
    'postal_code': '75011',
    'max_winner_count': 2,
    'state': 'open',
    'is_food_supply': true,
  },
];

const _seedTags = <Map<String, Object?>>[
  {
    'id': 'eeeeeee1-eeee-eeee-eeee-eeeeeeeeeee1',
    'label': 'Maison',
    'normalized_label': 'maison',
    'state': 'approved',
  },
  {
    'id': 'eeeeeee2-eeee-eeee-eeee-eeeeeeeeeee2',
    'label': 'Déco',
    'normalized_label': 'deco',
    'state': 'approved',
  },
  {
    'id': 'eeeeeee3-eeee-eeee-eeee-eeeeeeeeeee3',
    'label': 'Cuisine',
    'normalized_label': 'cuisine',
    'state': 'approved',
  },
  {
    'id': 'eeeeeee4-eeee-eeee-eeee-eeeeeeeeeee4',
    'label': 'Jardin',
    'normalized_label': 'jardin',
    'state': 'approved',
  },
  {
    'id': 'eeeeeee5-eeee-eeee-eeee-eeeeeeeeeee5',
    'label': 'Alimentaire',
    'normalized_label': 'alimentaire',
    'state': 'approved',
  },
];

const _seedDealTags = <Map<String, Object?>>[
  {
    'deal_id': 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    'tag_id': 'eeeeeee1-eeee-eeee-eeee-eeeeeeeeeee1',
  },
  {
    'deal_id': 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    'tag_id': 'eeeeeee2-eeee-eeee-eeee-eeeeeeeeeee2',
  },
  {
    'deal_id': 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
    'tag_id': 'eeeeeee3-eeee-eeee-eeee-eeeeeeeeeee3',
  },
  {
    'deal_id': 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
    'tag_id': 'eeeeeee5-eeee-eeee-eeee-eeeeeeeeeee5',
  },
];

const _seedApplications = <Map<String, Object?>>[
  {
    'id': 'bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
    'deal_id': 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    'applicant_profile_id': '22222222-2222-2222-2222-222222222222',
    'status': 'pending',
  },
  {
    'id': 'bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
    'deal_id': 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
    'applicant_profile_id': '33333333-3333-3333-3333-333333333333',
    'status': 'pending',
  },
];

const _seedReports = <Map<String, Object?>>[
  {
    'id': 'ccccccc1-cccc-cccc-cccc-ccccccccccc1',
    'reporter_profile_id': '22222222-2222-2222-2222-222222222222',
    'target_profile_id': '11111111-1111-1111-1111-111111111111',
    'target_deal_id': 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    'title': 'Signalement utilisateur',
    'description': 'Comportement inapproprié lors de la prise de contact.',
  },
];

const _seedProfileIds = <String>[
  '11111111-1111-1111-1111-111111111111',
  '22222222-2222-2222-2222-222222222222',
  '33333333-3333-3333-3333-333333333333',
];

const _seedDealIds = <String>[
  'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
  'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
];

const _seedApplicationIds = <String>[
  'bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
  'bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
];

const _seedReportIds = <String>[
  'ccccccc1-cccc-cccc-cccc-ccccccccccc1',
];

const _profileImagesBucket = 'profile-images';
const _dealImagesBucket = 'deal-images';

const _profileImagePathByProfileId = <String, String>{
  '11111111-1111-1111-1111-111111111111':
      '11111111-1111-1111-1111-111111111111/avatar.png',
  '22222222-2222-2222-2222-222222222222':
      '22222222-2222-2222-2222-222222222222/avatar.png',
  '33333333-3333-3333-3333-333333333333':
      '33333333-3333-3333-3333-333333333333/avatar.png',
};

final _profileImageBytesByProfileId = <String, Uint8List>{
  '11111111-1111-1111-1111-111111111111': _seedOrangePixel,
  '22222222-2222-2222-2222-222222222222': _seedBluePixel,
  '33333333-3333-3333-3333-333333333333': _seedGreenPixel,
};

final List<_DealSeedImage> _seedDealImageFixtures = <_DealSeedImage>[
  _DealSeedImage(
    id: 'ddddddd1-dddd-dddd-dddd-ddddddddddd1',
    dealId: 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    position: 0,
    storagePath: 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1/0.png',
    bytes: _seedOrangePixel,
  ),
  _DealSeedImage(
    id: 'ddddddd2-dddd-dddd-dddd-ddddddddddd2',
    dealId: 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    position: 1,
    storagePath: 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1/1.png',
    bytes: _seedBluePixel,
  ),
  _DealSeedImage(
    id: 'ddddddd3-dddd-dddd-dddd-ddddddddddd3',
    dealId: 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
    position: 0,
    storagePath: 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2/0.png',
    bytes: _seedGreenPixel,
  ),
];

final Uint8List _seedOrangePixel = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8z8AA'
  'RQMBg0xS0V8AAAAASUVORK5CYII=',
);
final Uint8List _seedBluePixel = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8A'
  'AT8B9M6mkHkAAAAASUVORK5CYII=',
);
final Uint8List _seedGreenPixel = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP4zwAA'
  'AgMBNQottwAAAABJRU5ErkJggg==',
);

class _DealSeedImage {
  const _DealSeedImage({
    required this.id,
    required this.dealId,
    required this.position,
    required this.storagePath,
    required this.bytes,
  });

  final String id;
  final String dealId;
  final int position;
  final String storagePath;
  final Uint8List bytes;
}

class _UploadedDealSeedImage {
  const _UploadedDealSeedImage({
    required this.id,
    required this.dealId,
    required this.position,
    required this.path,
    required this.publicUrl,
  });

  final String id;
  final String dealId;
  final int position;
  final String path;
  final String publicUrl;
}
