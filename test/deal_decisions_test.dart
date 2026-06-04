import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_buyer_details_page.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_seller_details_page.dart';
import 'package:shareplace/features/profiles/data/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';

void main() {
  final deal = Deal(
    id: 'deal-id',
    sellerProfileId: 'seller-id',
    title: 'Lots de vaisselle',
    description: 'Vaisselle propre disponible rapidement.',
    postalCode: '75001',
    maxWinnerCount: 3,
  );

  testWidgets('buyer interest is for one lot only', (tester) async {
    final dealRepository = _FakeDealRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: DealBuyerDetailsPage(
          deal: deal,
          dealRepository: dealRepository,
          profileRepository: const _FakeProfileRepository(
            profile: Profile(
              id: 'buyer-id',
              firstName: 'Baya',
              lastName: 'Diallo',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quantité souhaitée :'), findsNothing);

    await tester.tap(find.text('Je suis intéressé'));
    await tester.pumpAndSettle();

    expect(dealRepository.addedDealId, 'deal-id');
    expect(dealRepository.addedApplicantProfileId, 'buyer-id');
  });

  testWidgets('seller accepts and rejects pending applications', (
    tester,
  ) async {
    final dealRepository = _FakeDealRepository(
      applications: [
        DealApplicationRecord(
          id: 'application-1',
          dealId: 'deal-id',
          applicantProfileId: 'buyer-1',
          status: DealApplicationStatus.pending,
          createdAt: DateTime(2026),
        ),
        DealApplicationRecord(
          id: 'application-2',
          dealId: 'deal-id',
          applicantProfileId: 'buyer-2',
          status: DealApplicationStatus.pending,
          createdAt: DateTime(2026),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DealSellerDetailsPage(
          deal: deal,
          dealRepository: dealRepository,
          profileRepository: const _FakeProfileRepository(
            profiles: {
              'buyer-1': Profile(
                id: 'buyer-1',
                firstName: 'Nora',
                lastName: 'Petit',
              ),
              'buyer-2': Profile(
                id: 'buyer-2',
                firstName: 'Samir',
                lastName: 'Benali',
              ),
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nora Petit'), findsOneWidget);
    expect(find.text('Samir Benali'), findsOneWidget);

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Refuser').first);
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Accepter').last);
    await tester.pumpAndSettle();

    expect(dealRepository.rejectedApplicationIds, ['application-1']);
    expect(dealRepository.acceptedApplicationIds, ['application-2']);
  });
}

class _FakeProfileRepository implements ProfileRepository {
  const _FakeProfileRepository({this.profile, this.profiles = const {}});

  final Profile? profile;
  final Map<String, Profile> profiles;

  @override
  Future<Profile> create(Profile profile) async => profile;

  @override
  Future<Profile?> getByAuthUserId(String authUserId) async => profile;

  @override
  Future<Profile> getById(String id) async => profiles[id] ?? profile!;

  @override
  Future<Profile?> getCurrentProfile() async => profile;

  @override
  Future<Profile> update(Profile profile) async => profile;
}

class _FakeDealRepository implements DealRepository {
  _FakeDealRepository({this.applications = const []});

  final List<DealApplicationRecord> applications;
  final acceptedApplicationIds = <String>[];
  final rejectedApplicationIds = <String>[];
  String? addedDealId;
  String? addedApplicantProfileId;

  @override
  Future<void> acceptApplication(String applicationId) async {
    acceptedApplicationIds.add(applicationId);
  }

  @override
  Future<void> addApplication({
    required String dealId,
    required String applicantProfileId,
    int quantity = 1,
  }) async {
    addedDealId = dealId;
    addedApplicantProfileId = applicantProfileId;
  }

  @override
  Future<void> cancel(String id) async {}

  @override
  Future<Map<String, int>> countApplicationsByDealIds(
    List<String> dealIds,
  ) async => const {};

  @override
  Future<Deal> create(Deal deal) async => deal;

  @override
  Future<Deal> getById(String id) async => throw UnimplementedError();

  @override
  Future<List<DealApplicationRecord>> getApplicationsByApplicantProfileId(
    String applicantProfileId,
  ) async => const [];

  @override
  Future<List<DealApplicationRecord>> getApplicationsByDealIds(
    List<String> dealIds,
  ) async => applications;

  @override
  Future<List<Deal>> getBySellerProfileId(String sellerProfileId) async => [];

  @override
  Future<List<Deal>> getOpenDeals() async => [];

  @override
  Future<bool> hasApplication({
    required String dealId,
    required String applicantProfileId,
  }) async => false;

  @override
  Future<void> rejectApplication(String applicationId) async {
    rejectedApplicationIds.add(applicationId);
  }

  @override
  Future<void> removeApplication({
    required String dealId,
    required String applicantProfileId,
  }) async {}

  @override
  Future<Deal> update(Deal deal) async => deal;
}
