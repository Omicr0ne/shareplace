import 'dart:typed_data';

import 'package:shareplace/core/models/deal.dart';
import 'package:shareplace/core/models/profile.dart';
import 'package:shareplace/core/repositories/deal_repository.dart';
import 'package:shareplace/core/repositories/profile_repository.dart';
import 'package:shareplace/core/repositories/supabase_deal_repository.dart';
import 'package:shareplace/core/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/product/domain/entities/product_item.dart';

class DealsData {
  static final DealRepository _dealRepository = SupabaseDealRepository();
  static final ProfileRepository _profileRepository = SupabaseProfileRepository();
  static final Map<String, bool> _interestByProductId = {};
  static final Map<String, _ProductMetadata> _metadataByProductId = {};

  static final List<ProductItem> _fallbackProducts = [
    const ProductItem(
      id: 'seed-1',
      sellerProfileId: 'seed-seller-1',
      article: 'Canape vintage',
      vendeur: 'Steve',
      description: 'Canape confortable en bon etat.',
      ville: 'Lyon',
      tags: ['Maison', 'Deco'],
      images: const <Uint8List>[],
    ),
    const ProductItem(
      id: 'seed-2',
      sellerProfileId: 'seed-seller-2',
      article: 'Lampe design',
      vendeur: 'Alice',
      description: 'Lampe de chevet style scandinave.',
      ville: 'Paris',
      tags: ['Deco'],
      images: const <Uint8List>[],
    ),
    const ProductItem(
      id: 'seed-3',
      sellerProfileId: 'seed-seller-3',
      article: 'Table basse',
      vendeur: 'Bob',
      description: 'Table basse bois clair.',
      ville: 'Bordeaux',
      tags: ['Maison'],
      images: const <Uint8List>[],
    ),
    const ProductItem(
      id: 'seed-4',
      sellerProfileId: 'seed-seller-4',
      article: 'Chaise pliable',
      vendeur: 'David',
      description: 'Chaise pratique pour petit espace.',
      ville: 'Lille',
      tags: ['Maison', 'Jardin'],
      images: const <Uint8List>[],
    ),
    const ProductItem(
      id: 'seed-5',
      sellerProfileId: 'seed-seller-5',
      article: 'Miroir mural',
      vendeur: 'Eve',
      description: 'Miroir decoratif format vertical.',
      ville: 'Nantes',
      tags: ['Deco'],
      images: const <Uint8List>[],
    ),
  ];

  static Future<String?> currentProfileId() async {
    final profile = await _profileRepository.getCurrentProfile();
    return profile?.id;
  }

  static Future<List<ProductItem>> loadOpenDeals() async {
    try {
      final currentProfile = await _profileRepository.getCurrentProfile();
      final deals = await _dealRepository.getOpenDeals();
      final products = <ProductItem>[];

      for (final deal in deals) {
        final metadata = _metadataByProductId[deal.id];
        final sellerName = await _resolveSellerName(deal.sellerProfileId);
        products.add(
          _toProductItem(
            deal: deal,
            sellerName: sellerName,
            metadata: metadata,
            isOwnedByCurrentUser: currentProfile?.id == deal.sellerProfileId,
          ),
        );
      }

      return products;
    } on Object {
      return List<ProductItem>.from(_fallbackProducts);
    }
  }

  static Future<ProductItem> createDeal({
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

    final metadata = _ProductMetadata(
      tags: List.unmodifiable(tags),
      images: List.unmodifiable(images),
    );
    _metadataByProductId[createdDeal.id] = metadata;

    return _toProductItem(
      deal: createdDeal,
      sellerName: _displayName(currentProfile),
      metadata: metadata,
      isOwnedByCurrentUser: true,
    );
  }

  static Future<void> cancelDeal(String productId) async {
    await _dealRepository.cancel(productId);
    _interestByProductId.remove(productId);
    _metadataByProductId.remove(productId);
  }

  static bool isInterested(String productId) {
    return _interestByProductId[productId] ?? false;
  }

  static bool toggleInterest(String productId) {
    final newValue = !isInterested(productId);
    _interestByProductId[productId] = newValue;
    return newValue;
  }

  static _ProductMetadata _fallbackMetadata(Deal deal) {
    return _metadataByProductId[deal.id] ?? _ProductMetadata(
      tags: deal.isFoodSupply ? ['Alimentaire'] : ['Offre'],
      images: const [],
    );
  }

  static ProductItem _toProductItem({
    required Deal deal,
    required String sellerName,
    required _ProductMetadata? metadata,
    required bool isOwnedByCurrentUser,
  }) {
    final effectiveMetadata = metadata ?? _fallbackMetadata(deal);
    return ProductItem(
      id: deal.id,
      sellerProfileId: deal.sellerProfileId,
      article: deal.title,
      vendeur: isOwnedByCurrentUser ? 'Vous' : sellerName,
      description: deal.description,
      ville: deal.postalCode,
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

class _ProductMetadata {
  const _ProductMetadata({
    required this.tags,
    required this.images,
  });

  final List<String> tags;
  final List<Uint8List> images;
}
