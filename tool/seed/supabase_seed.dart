import 'dart:io';

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

  await client.from('profiles').upsert(_seedProfiles, onConflict: 'id');
  await client.from('deals').upsert(_seedDeals, onConflict: 'id');
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
  await client.from('deals').delete().inFilter('id', _seedDealIds);
  await client.from('profiles').delete().inFilter('id', _seedProfileIds);

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
