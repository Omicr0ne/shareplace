import 'package:shareplace/features/deals/domain/entities/deal.dart';

enum DealApplicationStatus {
  pending,
  accepted,
  rejected,
  cancelled,
}

class DealApplicationRecord {
  const DealApplicationRecord({
    required this.id,
    required this.dealId,
    required this.applicantProfileId,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String dealId;
  final String applicantProfileId;
  final DealApplicationStatus status;
  final DateTime createdAt;
}

abstract interface class DealRepository {
  Future<Deal> getById(String id);
  Future<List<Deal>> getBySellerProfileId(String sellerProfileId);
  Future<List<Deal>> getOpenDeals();
  Future<Deal> create(Deal deal);
  Future<Deal> update(Deal deal);
  Future<void> cancel(String id);
  Future<Map<String, int>> countApplicationsByDealIds(List<String> dealIds);
  Future<bool> hasApplication({
    required String dealId,
    required String applicantProfileId,
  });
  Future<void> addApplication({
    required String dealId,
    required String applicantProfileId,
    int quantity,
  });
  Future<void> acceptApplication(String applicationId);
  Future<void> rejectApplication(String applicationId);
  Future<void> removeApplication({
    required String dealId,
    required String applicantProfileId,
  });
  Future<List<DealApplicationRecord>> getApplicationsByDealIds(
    List<String> dealIds,
  );
  Future<List<DealApplicationRecord>> getApplicationsByApplicantProfileId(
    String applicantProfileId,
  );
}
