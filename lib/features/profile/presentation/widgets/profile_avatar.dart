import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.placeholderUrl,
    required this.onPickImage,
    required this.onDeleteImage,
    this.imageUrl,
    this.imageBytes,
    super.key,
  });

  final String placeholderUrl;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final VoidCallback onPickImage;
  final VoidCallback onDeleteImage;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Modifier la photo de profil',
      child: InkWell(
        key: const Key('profile-avatar'),
        customBorder: const CircleBorder(),
        onTap: () => unawaited(_showPictureActions(context)),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 68,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              foregroundImage: _avatarImageProvider(),
              onForegroundImageError: (_, _) {},
              child: Icon(
                Icons.person,
                size: 56,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _avatarImageProvider() {
    final bytes = imageBytes;
    if (bytes != null) {
      return MemoryImage(bytes);
    }

    return NetworkImage(imageUrl ?? placeholderUrl);
  }

  Future<void> _showPictureActions(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Importer une photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  onPickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Supprimer la photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  onDeleteImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
