import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDealRepository implements DealRepository {
  SupabaseDealRepository({SupabaseClient? client}) : this._(client);

  const SupabaseDealRepository._(this._client);

  final SupabaseClient? _client;

  SupabaseClient? get _clientOrNull {
    if (_client != null) {
      return _client;
    }

    try {
      return Supabase.instance.client;
    } on Object {
      return null;
    }
  }

  @override
  Future<Deal> getById(String id) async {
    final response = await _requireClient()
        .from('deals')
        .select()
        .eq('id', id)
        .single();

    return Deal.fromJson(Map<String, Object?>.from(response));
  }

  @override
  Future<List<Deal>> getBySellerProfileId(String sellerProfileId) async {
    final response = await _requireClient()
        .from('deals')
        .select()
        .eq('seller_profile_id', sellerProfileId)
        .order('created_at', ascending: false);

    return response
        .map((json) => Deal.fromJson(Map<String, Object?>.from(json)))
        .toList(growable: false);
  }

  @override
  Future<List<Deal>> getOpenDeals() async {
    final response = await _requireClient()
        .from('deals')
        .select()
        .eq('state', DealState.open.name)
        .order('created_at', ascending: false);

    return response
        .map((json) => Deal.fromJson(Map<String, Object?>.from(json)))
        .toList(growable: false);
  }

  @override
  Future<Deal> create(Deal deal) async {
    final response = await _requireClient()
        .from('deals')
        .insert(deal.toJson())
        .select()
        .single();

    return Deal.fromJson(Map<String, Object?>.from(response));
  }

  @override
  Future<Deal> update(Deal deal) async {
    final response = await _requireClient()
        .from('deals')
        .update(deal.toJson())
        .eq('id', deal.id)
        .select()
        .single();

    return Deal.fromJson(Map<String, Object?>.from(response));
  }

  @override
  Future<void> cancel(String id) async {
    await _requireClient()
        .from('deals')
        .update({'state': DealState.cancelled.name})
        .eq('id', id);
  }

  SupabaseClient _requireClient() {
    final client = _clientOrNull;
    if (client == null) {
      throw StateError('Supabase is not initialized.');
    }

    return client;
  }
}
