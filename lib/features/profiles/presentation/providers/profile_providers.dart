import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareplace/core/supabase/supabase_client_provider.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return SupabaseProfileRepository(
    client: ref.watch(supabaseClientProvider),
  );
});

final currentProfileProvider = FutureProvider<Profile?>((ref) {
  return ref.watch(profileRepositoryProvider).getCurrentProfile();
});
