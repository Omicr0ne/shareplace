import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/core/models/user_profile.dart';
import 'package:shareplace/core/widgets/app_header.dart';
import 'package:shareplace/features/auth/data/auth_service.dart';
import 'package:shareplace/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:shareplace/features/profile/presentation/widgets/profile_description_field.dart';
import 'package:shareplace/features/profile/presentation/widgets/profile_identity_fields.dart';
import 'package:shareplace/features/profile/presentation/widgets/profile_logout_button.dart';
import 'package:shareplace/features/profile/presentation/widgets/profile_verification_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    this.initialProfile,
    super.key,
  });

  final UserProfile? initialProfile;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _placeholderAvatarUrl =
      'https://api.dicebear.com/10.x/adventurer/png?seed=SharePlace';

  late UserProfile _profile =
      widget.initialProfile ??
      const UserProfile(
        id: 'placeholder-profile',
        firstName: 'Share',
        lastName: 'Place',
        description:
            'Décris ton profil pour aider les autres à mieux te connaître.',
      );
  Uint8List? _selectedImageBytes;
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
              children: [
                AppHeader(
                  title: 'Profil',
                  onBack: _goHome,
                ),
                const SizedBox(height: 32),
                Align(
                  child: ProfileAvatar(
                    placeholderUrl: _placeholderAvatarUrl,
                    imageUrl: _profile.profilePictureUrl,
                    imageBytes: _selectedImageBytes,
                    onPickImage: _pickProfilePicture,
                    onDeleteImage: _deleteProfilePicture,
                  ),
                ),
                const SizedBox(height: 32),
                ProfileVerificationButton(
                  status: _profile.studentVerificationStatus,
                  onPressed: _goProfileVerification,
                ),
                const SizedBox(height: 24),
                ProfileIdentityFields(
                  firstName: _profile.firstName,
                  lastName: _profile.lastName,
                  onFirstNameChanged: _updateFirstName,
                  onLastNameChanged: _updateLastName,
                ),
                const SizedBox(height: 24),
                ProfileDescriptionField(
                  initialDescription: _profile.description,
                  onChanged: _updateDescription,
                ),
                const SizedBox(height: 24),
                ProfileLogoutButton(onPressed: _showSignOutConfirmation),
              ],
            ),
          ),
        ),
      ),
    );
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
      _profile = _profile.copyWith(profilePictureUrl: null);
    });
  }

  void _deleteProfilePicture() {
    setState(() {
      _selectedImageBytes = null;
      _profile = _profile.copyWith(profilePictureUrl: null);
    });
  }

  void _updateDescription(String description) {
    _profile = _profile.copyWith(description: description);
  }

  void _updateFirstName(String firstName) {
    _profile = _profile.copyWith(firstName: firstName);
  }

  void _updateLastName(String lastName) {
    _profile = _profile.copyWith(lastName: lastName);
  }

  void _goHome() {
    unawaited(
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
    );
  }

  void _goProfileVerification() {
    unawaited(Navigator.of(context).pushNamed(AppRoutes.profileVerification));
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
    unawaited(
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false),
    );
  }
}
