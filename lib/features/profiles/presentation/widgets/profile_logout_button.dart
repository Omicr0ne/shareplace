import 'package:flutter/material.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      key: const Key('profile-logout-button'),
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
        minimumSize: const Size.fromHeight(52),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.logout),
      label: const Text('Déconnexion'),
    );
  }
}
