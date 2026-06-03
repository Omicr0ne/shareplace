import 'package:shareplace/core/models/profile.dart';
import 'package:shareplace/core/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository({SupabaseClient? client}) : this._(client);

  const SupabaseProfileRepository._(this._client);

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
  Future<Profile?> getCurrentProfile() async {
    final client = _clientOrNull;
    final user = client?.auth.currentSession?.user;
    if (client == null || user == null) {
      return null;
    }

    return getByAuthUserId(user.id);
  }

  @override
  Future<Profile?> getByAuthUserId(String authUserId) async {
    final client = _requireClient();
    final response = await client
        .from('profiles')
        .select()
        .eq('auth_user_id', authUserId)
        .maybeSingle();
    if (response == null) {
      return null;
    }

    return Profile.fromJson(Map<String, Object?>.from(response));
  }

  @override
  Future<Profile> getById(String id) async {
    final client = _requireClient();
    final response = await client
        .from('profiles')
        .select()
        .eq('id', id)
        .single();

    return Profile.fromJson(Map<String, Object?>.from(response));
  }

  @override
  Future<Profile> create(Profile profile) async {
    final client = _requireClient();
    final response = await client
        .from('profiles')
        .insert(profile.toJson())
        .select()
        .single();

    return Profile.fromJson(Map<String, Object?>.from(response));
  }

  @override
  Future<Profile> update(Profile profile) async {
    final client = _requireClient();
    final response = await client
        .from('profiles')
        .update(profile.toJson())
        .eq('id', profile.id)
        .select()
        .single();

    return Profile.fromJson(Map<String, Object?>.from(response));
  }

  SupabaseClient _requireClient() {
    final client = _clientOrNull;
    if (client == null) {
      throw StateError('Supabase is not initialized.');
    }

    return client;
  }
}
