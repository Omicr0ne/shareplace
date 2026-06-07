import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareplace/core/supabase/supabase_client_provider.dart';
import 'package:shareplace/features/deals/data/repositories/supabase_deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';

final dealRepositoryProvider = Provider<DealRepository>((ref) {
  return SupabaseDealRepository(
    client: ref.watch(supabaseClientProvider),
  );
});

final openDealsProvider = FutureProvider<List<Deal>>((ref) {
  return ref.watch(dealRepositoryProvider).getOpenDeals();
});

FutureProvider<List<Deal>> sellerDealsProvider(String sellerProfileId) {
  return FutureProvider<List<Deal>>((ref) {
    return ref
        .watch(dealRepositoryProvider)
        .getBySellerProfileId(sellerProfileId);
  });
}
