import 'dart:typed_data';

import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/deal_application.dart';
import 'package:shareplace/features/deals/domain/entities/deal_search_filters.dart';

abstract interface class DealRepository {
  Future<Deal> getById(String id);
  Future<List<Deal>> getBySellerProfileId(String sellerProfileId);
  Future<List<Deal>> getOpenDeals();
  Future<List<Deal>> searchOpenDeals(DealSearchFilters filters);
  Future<Deal> create(Deal deal);
  Future<Deal> addImages({required Deal deal, required List<Uint8List> images});
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
