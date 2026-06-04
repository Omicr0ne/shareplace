import 'package:shareplace/features/deals/domain/entities/deal.dart';

abstract interface class DealRepository {
  Future<Deal> getById(String id);
  Future<List<Deal>> getBySellerProfileId(String sellerProfileId);
  Future<List<Deal>> getOpenDeals();
  Future<Deal> create(Deal deal);
  Future<Deal> update(Deal deal);
  Future<void> cancel(String id);
}
