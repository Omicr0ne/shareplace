import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/core/widgets/app_page_scaffold.dart';
import 'package:shareplace/features/auth/data/auth_service.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/presentation/widgets/profile_avatar.dart';
import 'package:shareplace/features/profiles/presentation/widgets/profile_description_field.dart';
import 'package:shareplace/features/profiles/presentation/widgets/profile_identity_fields.dart';
import 'package:shareplace/features/profiles/presentation/widgets/profile_logout_button.dart';
import 'package:shareplace/features/profiles/presentation/widgets/profile_verification_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    this.initialProfile,
    this.profileRepository,
    super.key,
  });

  final Profile? initialProfile;
  final ProfileRepository? profileRepository;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _placeholderAvatarUrl =
      'https://api.dicebear.com/10.x/adventurer/png?seed=SharePlace';

  Profile? _profile;
  Uint8List? _selectedImageBytes;
  final _authService = AuthService();
  late final ProfileRepository _profileRepository;

  @override
  void initState() {
    super.initState();
    _profileRepository =
        widget.profileRepository ?? SupabaseProfileRepository();
    final initialProfile = widget.initialProfile;
    if (initialProfile != null) {
      _profile = initialProfile;
      return;
    }

    unawaited(_loadCurrentProfile());
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    if (profile == null) {
      return const AppPageScaffold(
        title: 'Profil',
        currentRoute: AppRoutes.profile,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AppPageScaffold(
      title: 'Profil',
      currentRoute: AppRoutes.profile,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            children: [
              Align(
                child: ProfileAvatar(
                  placeholderUrl: _placeholderAvatarUrl,
                  imageUrl: profile.profilePictureUrl,
                  imageBytes: _selectedImageBytes,
                  onPickImage: _pickProfilePicture,
                  onDeleteImage: _deleteProfilePicture,
                ),
              ),
              const SizedBox(height: 32),
              ProfileVerificationButton(
                status: profile.studentVerificationStatus,
                onPressed: _goProfileVerification,
              ),
              const SizedBox(height: 24),
              ProfileIdentityFields(
                firstName: profile.firstName,
                lastName: profile.lastName,
                onFirstNameChanged: _updateFirstName,
                onLastNameChanged: _updateLastName,
              ),
              const SizedBox(height: 24),
              ProfileDescriptionField(
                initialDescription: profile.description,
                onChanged: _updateDescription,
              ),
              const SizedBox(height: 24),
              ProfileLogoutButton(onPressed: _showSignOutConfirmation),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadCurrentProfile() async {
    final Profile? profile;
    try {
      profile = await _profileRepository.getCurrentProfile();
    } on Object {
      if (!mounted) {
        return;
      }
      _goSignIn();
      return;
    }

    if (!mounted) {
      return;
    }
    if (profile == null) {
      _goSignIn();
      return;
    }

    setState(() {
      _profile = profile;
    });
  }

  Future<void> _pickProfilePicture() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (pickedImage == null || !mounted) {
      return;
    }

    final bytes = await pickedImage.readAsBytes();
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedImageBytes = bytes;
      _profile = _profile?.copyWith(profilePictureUrl: null);
    });
  }

  void _deleteProfilePicture() {
    setState(() {
      _selectedImageBytes = null;
      _profile = _profile?.copyWith(profilePictureUrl: null);
    });
  }

  void _updateDescription(String description) {
    _profile = _profile?.copyWith(description: description);
  }

  void _updateFirstName(String firstName) {
    _profile = _profile?.copyWith(firstName: firstName);
  }

  void _updateLastName(String lastName) {
    _profile = _profile?.copyWith(lastName: lastName);
  }

  void _goProfileVerification() {
    unawaited(Navigator.of(context).pushNamed(AppRoutes.studentVerification));
  }

  Future<void> _showSignOutConfirmation() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Confirmer la déconnexion ?'),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                unawaited(_signOut());
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (!mounted) {
      return;
    }
    _goSignIn();
  }

  void _goSignIn() {
    unawaited(
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.signIn, (_) => false),
    );
  }
}
