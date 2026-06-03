import 'package:shareplace/core/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  SupabaseClient? get _clientOrNull {
    try {
      return Supabase.instance.client;
    } on Object {
      return null;
    }
  }

  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final client = _clientOrNull;
    if (client == null) {
      throw StateError('Supabase is not initialized.');
    }

    return client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    final client = _clientOrNull;
    if (client == null) {
      throw StateError('Supabase is not initialized.');
    }

    return client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _clientOrNull?.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final session = _clientOrNull?.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    final client = _clientOrNull;
    final user = client?.auth.currentSession?.user;
    if (client == null || user == null) {
      return null;
    }

    final response = await client
        .from('profiles')
        .select()
        .eq('auth_user_id', user.id)
        .maybeSingle();
    if (response == null) {
      return null;
    }

    return UserProfile.fromJson(Map<String, Object?>.from(response));
  }
}
