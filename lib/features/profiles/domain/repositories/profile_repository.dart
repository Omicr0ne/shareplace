import 'package:shareplace/features/profiles/domain/entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Profile?> getCurrentProfile();
  Future<Profile?> getByAuthUserId(String authUserId);
  Future<Profile> getById(String id);
  Future<Profile> create(Profile profile);
  Future<Profile> update(Profile profile);
}
