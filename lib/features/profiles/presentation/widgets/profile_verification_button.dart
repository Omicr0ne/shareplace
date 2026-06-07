import 'package:flutter/material.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';

class ProfileVerificationButton extends StatelessWidget {
  const ProfileVerificationButton({
    required this.status,
    required this.onPressed,
    super.key,
  });

  final StudentVerificationStatus status;
  final VoidCallback onPressed;

  bool get _isVerified => status == StudentVerificationStatus.verified;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      key: const Key('profile-verification-button'),
      style: FilledButton.styleFrom(
        backgroundColor: _isVerified
            ? Colors.green
            : Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
      ),
      onPressed: _isVerified ? null : onPressed,
      icon: Icon(_isVerified ? Icons.verified : Icons.verified_user_outlined),
      label: Text(_isVerified ? 'Compte vérifié' : 'Vérifier mon compte'),
    );
  }
}
