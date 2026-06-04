import 'package:shareplace/features/deals/data/repositories/deal_tag_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDealTagRepository implements DealTagRepository {
  SupabaseDealTagRepository({SupabaseClient? client}) : this._(client);

  const SupabaseDealTagRepository._(this._client);

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
  Future<void> setTagsForDeal(String dealId, List<String> tags) async {
    final client = _requireClient();
    final uniqueTags = tags.toSet().toList(growable: false);
    if (uniqueTags.isEmpty) {
      return;
    }

    final tagRows = await client
        .from('tags')
        .select('id,label')
        .inFilter('label', uniqueTags);

    final tagIdsByName = {
      for (final row in tagRows) row['label']! as String: row['id']! as String,
    };

    final missingTags = uniqueTags
        .where((tag) => !tagIdsByName.containsKey(tag))
        .toList(growable: false);
    if (missingTags.isNotEmpty) {
      throw StateError('Unknown deal tags: ${missingTags.join(', ')}.');
    }

    await client
        .from('deal_tags')
        .insert(
          uniqueTags
              .map(
                (tag) => {
                  'deal_id': dealId,
                  'tag_id': tagIdsByName[tag],
                },
              )
              .toList(growable: false),
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