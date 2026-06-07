import 'dart:typed_data';

import 'package:shareplace/features/deals/data/repositories/supabase_deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/deal_card_item.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';

class DealsData {
  static final DealRepository _dealRepository = SupabaseDealRepository();
  static final ProfileRepository _profileRepository =
      SupabaseProfileRepository();
  static final Map<String, bool> _interestByDealId = {};
  static final Map<String, _DealMetadata> _metadataByDealId = {};

  static final List<DealCardItem> _fallbackDeals = [
    const DealCardItem(
      id: 'seed-1',
      sellerProfileId: 'seed-seller-1',
      title: 'Canape vintage',
      sellerName: 'Steve',
      description: 'Canape confortable en bon etat.',
      postalCode: 'Lyon',
      tags: ['Maison', 'Deco'],
      images: <Uint8List>[],
    ),
    const DealCardItem(
      id: 'seed-2',
      sellerProfileId: 'seed-seller-2',
      title: 'Lampe design',
      sellerName: 'Alice',
      description: 'Lampe de chevet style scandinave.',
      postalCode: 'Paris',
      tags: ['Deco'],
      images: <Uint8List>[],
    ),
    const DealCardItem(
      id: 'seed-3',
      sellerProfileId: 'seed-seller-3',
      title: 'Table basse',
      sellerName: 'Bob',
      description: 'Table basse bois clair.',
      postalCode: 'Bordeaux',
      tags: ['Maison'],
      images: <Uint8List>[],
    ),
    const DealCardItem(
      id: 'seed-4',
      sellerProfileId: 'seed-seller-4',
      title: 'Chaise pliable',
      sellerName: 'David',
      description: 'Chaise pratique pour petit espace.',
      postalCode: 'Lille',
      tags: ['Maison', 'Jardin'],
      images: <Uint8List>[],
    ),
    const DealCardItem(
      id: 'seed-5',
      sellerProfileId: 'seed-seller-5',
      title: 'Miroir mural',
      sellerName: 'Eve',
      description: 'Miroir decoratif format vertical.',
      postalCode: 'Nantes',
      tags: ['Deco'],
      images: <Uint8List>[],
    ),
  ];

  static Future<String?> currentProfileId() async {
    final profile = await _profileRepository.getCurrentProfile();
    return profile?.id;
  }

  static Future<List<DealCardItem>> loadOpenDeals() async {
    try {
      final currentProfile = await _profileRepository.getCurrentProfile();
      final deals = await _dealRepository.getOpenDeals();
      final dealItems = <DealCardItem>[];

      for (final deal in deals) {
        final metadata = _metadataByDealId[deal.id];
        final sellerName = await _resolveSellerName(deal.sellerProfileId);
        dealItems.add(
          _toDealCardItem(
            deal: deal,
            sellerName: sellerName,
            metadata: metadata,
            isOwnedByCurrentUser: currentProfile?.id == deal.sellerProfileId,
          ),
        );
      }

      return dealItems;
    } on Object {
      return List<DealCardItem>.from(_fallbackDeals);
    }
  }

  static Future<DealCardItem> createDeal({
    required String title,
    required String description,
    required String postalCode,
    required List<String> tags,
    required List<Uint8List> images,
  }) async {
    final currentProfile = await _profileRepository.getCurrentProfile();
    if (currentProfile == null) {
      throw StateError('No current profile found.');
    }

    final createdDeal = await _dealRepository.create(
      Deal(
        id: '',
        sellerProfileId: currentProfile.id,
        title: title,
        description: description,
        postalCode: postalCode,
      ),
    );

    final metadata = _DealMetadata(
      tags: List.unmodifiable(tags),
      images: List.unmodifiable(images),
    );
    _metadataByDealId[createdDeal.id] = metadata;

    return _toDealCardItem(
      deal: createdDeal,
      sellerName: _displayName(currentProfile),
      metadata: metadata,
      isOwnedByCurrentUser: true,
    );
  }

  static Future<void> cancelDeal(String dealId) async {
    await _dealRepository.cancel(dealId);
    _interestByDealId.remove(dealId);
    _metadataByDealId.remove(dealId);
  }

  static bool isInterested(String dealId) {
    return _interestByDealId[dealId] ?? false;
  }

  static bool toggleInterest(String dealId) {
    final newValue = !isInterested(dealId);
    _interestByDealId[dealId] = newValue;
    return newValue;
  }

  static _DealMetadata _fallbackMetadata(Deal deal) {
    return _metadataByDealId[deal.id] ??
        _DealMetadata(
          tags: deal.isFoodSupply ? ['Alimentaire'] : ['Offre'],
          images: const [],
        );
  }

  static DealCardItem _toDealCardItem({
    required Deal deal,
    required String sellerName,
    required _DealMetadata? metadata,
    required bool isOwnedByCurrentUser,
  }) {
    final effectiveMetadata = metadata ?? _fallbackMetadata(deal);
    return DealCardItem(
      id: deal.id,
      sellerProfileId: deal.sellerProfileId,
      title: deal.title,
      sellerName: isOwnedByCurrentUser ? 'Vous' : sellerName,
      description: deal.description,
      postalCode: deal.postalCode,
      tags: effectiveMetadata.tags,
      images: effectiveMetadata.images,
    );
  }

  static Future<String> _resolveSellerName(String profileId) async {
    try {
      final profile = await _profileRepository.getById(profileId);
      return _displayName(profile);
    } on Object {
      return 'Vendeur';
    }
  }

  static String _displayName(Profile profile) {
    final firstName = profile.firstName;
    final lastName = profile.lastName;
    final parts = <String>[
      if (firstName.isNotEmpty) firstName,
      if (lastName.isNotEmpty) lastName,
    ];

    if (parts.isNotEmpty) {
      return parts.join(' ');
    }

    return 'Vendeur';
  }
}

class _DealMetadata {
  const _DealMetadata({
    required this.tags,
    required this.images,
  });

  final List<String> tags;
  final List<Uint8List> images;
}
