import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDealRepository implements DealRepository {
  SupabaseDealRepository({SupabaseClient? client}) : this._(client);

  const SupabaseDealRepository._(this._client);

  static const _applicationsTable = 'deal_applications';
  static const _applicantColumns = [
    'applicant_profile_id',
    'profile_id',
    'applicant_id',
  ];

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
      counts.update(row.dealId, (current) => current + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  @override
  Future<bool> hasApplication({
    required String dealId,
    required String applicantProfileId,
  }) async {
    final applicantColumn = await _resolveApplicantColumn();
    final response = await _requireClient()
        .from(_applicationsTable)
        .select('id')
        .eq('deal_id', dealId)
        .eq(applicantColumn, applicantProfileId)
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
    final applicantColumn = await _resolveApplicantColumn();
    try {
      await client.from(_applicationsTable).insert({
        'deal_id': dealId,
        applicantColumn: applicantProfileId,
        'quantity': quantity,
      });
      return;
    } on PostgrestException {
      await client.from(_applicationsTable).insert({
        'deal_id': dealId,
        applicantColumn: applicantProfileId,
      });
    }
  }

  @override
  Future<void> removeApplication({
    required String dealId,
    required String applicantProfileId,
  }) async {
    final applicantColumn = await _resolveApplicantColumn();
    await _requireClient()
        .from(_applicationsTable)
        .delete()
        .eq('deal_id', dealId)
        .eq(applicantColumn, applicantProfileId);
  }

  @override
  Future<List<DealApplicationRecord>> getApplicationsByDealIds(
    List<String> dealIds,
  ) async {
    if (dealIds.isEmpty) {
      return const [];
    }
    final applicantColumn = await _resolveApplicantColumn();
    final response = await _requireClient()
        .from(_applicationsTable)
        .select('id,deal_id,created_at,$applicantColumn')
        .inFilter('deal_id', dealIds)
        .order('created_at', ascending: false);
    return _parseApplicationRows(response, applicantColumn: applicantColumn);
  }

  @override
  Future<List<DealApplicationRecord>> getApplicationsByApplicantProfileId(
    String applicantProfileId,
  ) async {
    final applicantColumn = await _resolveApplicantColumn();
    final response = await _requireClient()
        .from(_applicationsTable)
        .select('id,deal_id,created_at,$applicantColumn')
        .eq(applicantColumn, applicantProfileId)
        .order('created_at', ascending: false);
    return _parseApplicationRows(response, applicantColumn: applicantColumn);
  }

  List<DealApplicationRecord> _parseApplicationRows(
    dynamic response, {
    required String applicantColumn,
  }) {
    final rows = (response as List<dynamic>).cast<Map<String, dynamic>>();
    return rows
        .map(
          (row) => DealApplicationRecord(
            id: row['id'] as String? ?? '',
            dealId: row['deal_id'] as String? ?? '',
            applicantProfileId: row[applicantColumn] as String? ?? '',
            createdAt: _toDateTime(row['created_at']) ?? DateTime.now(),
          ),
        )
        .where(
          (row) => row.dealId.isNotEmpty && row.applicantProfileId.isNotEmpty,
        )
        .toList(growable: false);
  }

  Future<String> _resolveApplicantColumn() async {
    final client = _requireClient();
    for (final column in _applicantColumns) {
      try {
        await client.from(_applicationsTable).select(column).limit(1);
        return column;
      } on PostgrestException {
        continue;
      }
    }
    throw StateError(
      'Missing applicant profile column in deal_applications. '
      'Expected one of: ${_applicantColumns.join(', ')}.',
    );
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
