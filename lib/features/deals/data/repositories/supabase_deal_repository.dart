import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/deal_application.dart';
import 'package:shareplace/features/deals/domain/entities/deal_search_filters.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDealRepository implements DealRepository {
  SupabaseDealRepository({SupabaseClient? client}) : this._(client);

  const SupabaseDealRepository._(this._client);

  static const _applicationsTable = 'deal_applications';

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
    return searchOpenDeals(const DealSearchFilters());
  }

  @override
  Future<List<Deal>> searchOpenDeals(DealSearchFilters filters) async {
    final tags = filters.tags.where((tag) => tag.trim().isNotEmpty).toList();
    final selectColumns = tags.isEmpty
        ? '*'
        : '*, deal_tags!inner(tags!inner(label,state))';
    var query = _requireClient()
        .from('deals')
        .select(selectColumns)
        .eq('state', DealState.open.name);

    final searchQuery = filters.query?.trim();
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final escapedQuery = searchQuery.replaceAll('%', r'\%');
      final textFilters = [
        'title.ilike.%$escapedQuery%',
        'description.ilike.%$escapedQuery%',
        'postal_code.ilike.%$escapedQuery%',
      ];
      query = query.or(
        textFilters.join(','),
      );
    }

    final postalCode = filters.postalCode?.trim();
    if (postalCode != null && postalCode.isNotEmpty) {
      query = query.ilike('postal_code', '$postalCode%');
    }

    final isFoodSupply = filters.isFoodSupply;
    if (isFoodSupply != null) {
      query = query.eq('is_food_supply', isFoodSupply);
    }

    if (tags.isNotEmpty) {
      query = query
          .eq('deal_tags.tags.state', 'approved')
          .inFilter('deal_tags.tags.label', tags);
    }

    final response = await query.order('created_at', ascending: false);

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

  @override
  Future<Map<String, int>> countApplicationsByDealIds(
    List<String> dealIds,
  ) async {
    if (dealIds.isEmpty) {
      return const {};
    }
    final rows = await getApplicationsByDealIds(dealIds);
    final counts = <String, int>{for (final id in dealIds) id: 0};
    for (final row in rows) {
      if (row.status != DealApplicationStatus.pending) {
        continue;
      }
      counts.update(row.dealId, (current) => current + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  @override
  Future<bool> hasApplication({
    required String dealId,
    required String applicantProfileId,
  }) async {
    final response = await _requireClient()
        .from(_applicationsTable)
        .select('id')
        .eq('deal_id', dealId)
        .eq('applicant_profile_id', applicantProfileId)
        .inFilter('status', [
          DealApplicationStatus.pending.name,
          DealApplicationStatus.accepted.name,
          DealApplicationStatus.rejected.name,
        ])
        .limit(1)
        .maybeSingle();
    return response != null;
  }

  @override
  Future<void> addApplication({
    required String dealId,
    required String applicantProfileId,
    int quantity = 1,
  }) async {
    final client = _requireClient();
    try {
      await client.from(_applicationsTable).insert({
        'deal_id': dealId,
        'applicant_profile_id': applicantProfileId,
        'status': DealApplicationStatus.pending.name,
        'quantity': quantity,
      });
      return;
    } on PostgrestException {
      await client.from(_applicationsTable).insert({
        'deal_id': dealId,
        'applicant_profile_id': applicantProfileId,
        'status': DealApplicationStatus.pending.name,
      });
    }
  }

  @override
  Future<void> acceptApplication(String applicationId) async {
    final client = _requireClient();
    final response = await client
        .from(_applicationsTable)
        .update({'status': DealApplicationStatus.accepted.name})
        .eq('id', applicationId)
        .select('deal_id')
        .single();
    final dealId = response['deal_id'] as String?;
    if (dealId == null || dealId.isEmpty) {
      return;
    }

    final deal = await getById(dealId);
    final acceptedRows = await client
        .from(_applicationsTable)
        .select('id')
        .eq('deal_id', dealId)
        .eq('status', DealApplicationStatus.accepted.name);
    if (acceptedRows.length < deal.maxWinnerCount) {
      return;
    }

    await client
        .from('deals')
        .update({'state': DealState.closed.name})
        .eq('id', dealId);
    await client
        .from(_applicationsTable)
        .update({'status': DealApplicationStatus.rejected.name})
        .eq('deal_id', dealId)
        .eq('status', DealApplicationStatus.pending.name);
  }

  @override
  Future<void> rejectApplication(String applicationId) async {
    await _requireClient()
        .from(_applicationsTable)
        .update({'status': DealApplicationStatus.rejected.name})
        .eq('id', applicationId);
  }

  @override
  Future<void> removeApplication({
    required String dealId,
    required String applicantProfileId,
  }) async {
    await _requireClient()
        .from(_applicationsTable)
        .update({
          'status': DealApplicationStatus.cancelled.name,
          'cancelled_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('deal_id', dealId)
        .eq('applicant_profile_id', applicantProfileId)
        .eq('status', DealApplicationStatus.pending.name);
  }

  @override
  Future<List<DealApplicationRecord>> getApplicationsByDealIds(
    List<String> dealIds,
  ) async {
    if (dealIds.isEmpty) {
      return const [];
    }
    final response = await _requireClient()
        .from(_applicationsTable)
        .select('id,deal_id,created_at,status,applicant_profile_id')
        .inFilter('deal_id', dealIds)
        .order('created_at', ascending: false);
    return _parseApplicationRows(response);
  }

  @override
  Future<List<DealApplicationRecord>> getApplicationsByApplicantProfileId(
    String applicantProfileId,
  ) async {
    final response = await _requireClient()
        .from(_applicationsTable)
        .select('id,deal_id,created_at,status,applicant_profile_id')
        .eq('applicant_profile_id', applicantProfileId)
        .order('created_at', ascending: false);
    return _parseApplicationRows(response);
  }

  List<DealApplicationRecord> _parseApplicationRows(dynamic response) {
    final rows = (response as List<dynamic>).cast<Map<String, dynamic>>();
    return rows
        .map(
          (row) => DealApplicationRecord(
            id: row['id'] as String? ?? '',
            dealId: row['deal_id'] as String? ?? '',
            applicantProfileId: row['applicant_profile_id'] as String? ?? '',
            status: _applicationStatusFromJson(row['status']),
            createdAt: _toDateTime(row['created_at']) ?? DateTime.now(),
          ),
        )
        .where(
          (row) => row.dealId.isNotEmpty && row.applicantProfileId.isNotEmpty,
        )
        .toList(growable: false);
  }

  SupabaseClient _requireClient() {
    final client = _clientOrNull;
    if (client == null) {
      throw StateError('Supabase is not initialized.');
    }

    return client;
  }
}

DateTime? _toDateTime(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }
  return DateTime.tryParse(value as String);
}

DealApplicationStatus _applicationStatusFromJson(Object? value) {
  final name = value as String? ?? DealApplicationStatus.pending.name;
  return DealApplicationStatus.values.firstWhere(
    (status) => status.name == name,
    orElse: () => DealApplicationStatus.pending,
  );
}
