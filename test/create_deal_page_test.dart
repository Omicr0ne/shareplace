import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/deal_application.dart';
import 'package:shareplace/features/deals/domain/entities/deal_search_filters.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_tag_repository.dart';
import 'package:shareplace/features/deals/presentation/pages/create_deal_page.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';

void main() {
  testWidgets('loads tag labels from repository', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateDealPage(
          dealRepository: _FakeDealRepository(),
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'current-profile-id',
              firstName: 'Lina',
              lastName: 'Martin',
            ),
          ),
          dealTagRepository: _FakeDealTagRepository(
            availableTags: ['Livre', 'Velo'],
          ),
          initialProductImages: [_transparentPng],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    expect(find.text('Livre'), findsOneWidget);
    expect(find.text('Velo'), findsOneWidget);
  });

  testWidgets('creates a deal with current profile as author and tags', (
    tester,
  ) async {
    final dealRepository = _FakeDealRepository();
    final tagRepository = _FakeDealTagRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: CreateDealPage(
          dealRepository: dealRepository,
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'current-profile-id',
              firstName: 'Lina',
              lastName: 'Martin',
            ),
          ),
          dealTagRepository: tagRepository,
          initialProductImages: [_transparentPng],
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, "Titre de l'offre"),
      'Canape convertible',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'Canape deux places en bon etat.',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Code postal'),
      '69001',
    );
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maison').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Continuer'));
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(dealRepository.createdDeal?.sellerProfileId, 'current-profile-id');
    expect(dealRepository.createdDeal?.title, 'Canape convertible');
    expect(tagRepository.createdDealId, 'created-deal-id');
    expect(tagRepository.createdTags, ['Maison']);
  });

  testWidgets('uploads selected images after creating the deal', (
    tester,
  ) async {
    final dealRepository = _FakeDealRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: CreateDealPage(
          dealRepository: dealRepository,
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'current-profile-id',
              firstName: 'Lina',
              lastName: 'Martin',
            ),
          ),
          dealTagRepository: _FakeDealTagRepository(),
          initialProductImages: [_transparentPng],
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, "Titre de l'offre"),
      'Canape convertible',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'Canape deux places en bon etat.',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Code postal'),
      '69001',
    );
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maison').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Continuer'));
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(dealRepository.imageDealId, 'created-deal-id');
    expect(dealRepository.uploadedImages, [_transparentPng]);
  });

  testWidgets('creates a new tag from the create deal form', (tester) async {
    final dealRepository = _FakeDealRepository();
    final tagRepository = _FakeDealTagRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: CreateDealPage(
          dealRepository: dealRepository,
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'current-profile-id',
              firstName: 'Lina',
              lastName: 'Martin',
            ),
          ),
          dealTagRepository: tagRepository,
          initialProductImages: [_transparentPng],
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, "Titre de l'offre"),
      'Canape convertible',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'Canape deux places en bon etat.',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Code postal'),
      '69001',
    );
    await tester.ensureVisible(
      find.byKey(const Key('create-deal-new-tag-field')),
    );
    await tester.enterText(
      find.byKey(const Key('create-deal-new-tag-field')),
      'Bricolage',
    );
    await tester.tap(find.text('Ajouter le tag'));
    await tester.pumpAndSettle();

    expect(tagRepository.createdTagLabels, ['Bricolage']);
    expect(tagRepository.createdByProfileIds, ['current-profile-id']);
    expect(find.widgetWithText(Chip, 'Bricolage'), findsOneWidget);

    await tester.ensureVisible(find.text('Continuer'));
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(dealRepository.createdDeal?.sellerProfileId, 'current-profile-id');
    expect(tagRepository.createdTags, ['Bricolage']);
  });

  testWidgets('does not create a deal when the last selected tag is removed', (
    tester,
  ) async {
    final dealRepository = _FakeDealRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: CreateDealPage(
          dealRepository: dealRepository,
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'current-profile-id',
              firstName: 'Lina',
              lastName: 'Martin',
            ),
          ),
          dealTagRepository: _FakeDealTagRepository(),
          initialProductImages: [_transparentPng],
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, "Titre de l'offre"),
      'Canape convertible',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'Canape deux places en bon etat.',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Code postal'),
      '69001',
    );
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maison').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.cancel).last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Continuer'));
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(dealRepository.createdDeal, isNull);
    expect(find.text('Tag requis'), findsOneWidget);
  });

  testWidgets('keeps the form open when tag association fails', (tester) async {
    final dealRepository = _FakeDealRepository();
    final tagRepository = _FakeDealTagRepository(throwOnSetTags: true);

    await tester.pumpWidget(
      MaterialApp(
        home: CreateDealPage(
          dealRepository: dealRepository,
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'current-profile-id',
              firstName: 'Lina',
              lastName: 'Martin',
            ),
          ),
          dealTagRepository: tagRepository,
          initialProductImages: [_transparentPng],
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, "Titre de l'offre"),
      'Canape convertible',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'Canape deux places en bon etat.',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Code postal'),
      '69001',
    );
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maison').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Continuer'));
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateDealPage), findsOneWidget);
    expect(dealRepository.cancelledDealId, 'created-deal-id');
    expect(
      find.text("Impossible de créer l'offre pour le moment."),
      findsOneWidget,
    );
  });
}

final _transparentPng = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

class _FakeProfileRepository implements ProfileRepository {
  const _FakeProfileRepository({required this.profile});

  final Profile? profile;

  @override
  Future<Profile> create(Profile profile) async => profile;

  @override
  Future<Profile?> getByAuthUserId(String authUserId) async => profile;

  @override
  Future<Profile> getById(String id) async => profile!;

  @override
  Future<Profile?> getCurrentProfile() async => profile;

  @override
  Future<Profile> update(Profile profile) async => profile;
}

class _FakeDealRepository implements DealRepository {
  Deal? createdDeal;
  String? cancelledDealId;
  String? imageDealId;
  List<Uint8List>? uploadedImages;

  @override
  Future<void> addApplication({
    required String dealId,
    required String applicantProfileId,
    int quantity = 1,
  }) async {}

  @override
  Future<void> acceptApplication(String applicationId) async {}

  @override
  Future<void> cancel(String id) async {
    cancelledDealId = id;
  }

  @override
  Future<Map<String, int>> countApplicationsByDealIds(
    List<String> dealIds,
  ) async {
    return {for (final id in dealIds) id: 0};
  }

  @override
  Future<Deal> create(Deal deal) async {
    createdDeal = deal;
    return deal.copyWith(id: 'created-deal-id');
  }

  @override
  Future<Deal> addImages({
    required Deal deal,
    required List<Uint8List> images,
  }) async {
    imageDealId = deal.id;
    uploadedImages = images.map(Uint8List.fromList).toList(growable: false);
    return deal.copyWith(
      imageUrls: [
        for (var index = 0; index < images.length; index += 1)
          'https://example.com/deals/${deal.id}/$index.png',
      ],
    );
  }

  @override
  Future<Deal> getById(String id) async => createdDeal!;

  @override
  Future<List<DealApplicationRecord>> getApplicationsByApplicantProfileId(
    String applicantProfileId,
  ) async {
    return const [];
  }

  @override
  Future<List<DealApplicationRecord>> getApplicationsByDealIds(
    List<String> dealIds,
  ) async {
    return const [];
  }

  @override
  Future<List<Deal>> getBySellerProfileId(String sellerProfileId) async => [];

  @override
  Future<List<Deal>> getOpenDeals() async => [];

  @override
  Future<List<Deal>> searchOpenDeals(DealSearchFilters filters) async => [];

  @override
  Future<bool> hasApplication({
    required String dealId,
    required String applicantProfileId,
  }) async {
    return false;
  }

  @override
  Future<void> rejectApplication(String applicationId) async {}

  @override
  Future<void> removeApplication({
    required String dealId,
    required String applicantProfileId,
  }) async {}

  @override
  Future<Deal> update(Deal deal) async => deal;
}

class _FakeDealTagRepository implements DealTagRepository {
  _FakeDealTagRepository({
    this.availableTags = const ['Maison', 'Déco', 'Cuisine', 'Jardin'],
    this.throwOnSetTags = false,
  });

  final List<String> availableTags;
  final bool throwOnSetTags;
  String? createdDealId;
  List<String>? createdTags;
  final List<String> createdTagLabels = [];
  final List<String> createdByProfileIds = [];

  @override
  Future<List<String>> getAvailableTags() async => availableTags;

  @override
  Future<void> setTagsForDeal(String dealId, List<String> tags) async {
    if (throwOnSetTags) {
      throw StateError('Unable to associate tags.');
    }
    createdDealId = dealId;
    createdTags = List<String>.from(tags);
  }

  @override
  Future<String> createTag({
    required String label,
    required String createdByProfileId,
  }) async {
    createdTagLabels.add(label);
    createdByProfileIds.add(createdByProfileId);
    return label;
  }
}
