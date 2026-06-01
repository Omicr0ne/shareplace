import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InscriptionScreenK extends StatefulWidget {
  const InscriptionScreenK({super.key});

  @override
  State<InscriptionScreenK> createState() => _InscriptionScreenKState();
}

class _InscriptionScreenKState extends State<InscriptionScreenK> {
  final _picker = ImagePicker();
  Uint8List? _profileImageBytes;
  String? _profileImageName;

  Future<void> _pickProfileImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return;
      }

      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImageBytes = bytes;
        _profileImageName = pickedFile.name;
      });
    } on Exception catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'importer la photo pour le moment."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle =
        ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.blue.shade900;
            }
            return Colors.blue;
          }),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.blue.shade50,
                    backgroundImage: _profileImageBytes != null
                        ? MemoryImage(_profileImageBytes!)
                        : null,
                    child: _profileImageBytes == null
                        ? const Icon(
                            Icons.person,
                            size: 42,
                            color: Colors.blue,
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickProfileImage,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(
                      _profileImageBytes == null
                          ? 'Importer une photo de profil'
                          : 'Changer la photo de profil',
                    ),
                  ),
                  if (_profileImageName != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _profileImageName!,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {},
                      child: const Text('Continuer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
