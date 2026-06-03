import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InscriptionScreenK extends StatefulWidget {
  const InscriptionScreenK({super.key});

  @override
  State<InscriptionScreenK> createState() => _InscriptionScreenKState();
}

class _InscriptionScreenKState extends State<InscriptionScreenK> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();
  Uint8List? _profileImageBytes;
  String? _profileImageName;
  bool _showProfileImageError = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

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
        _showProfileImageError = false;
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

  String? _descriptionValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez renseigner la description';
    }
    return null;
  }

  void _submitStepTwo() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final hasProfileImage = _profileImageBytes != null;

    setState(() {
      _showProfileImageError = !hasProfileImage;
    });

    if (!isFormValid || !hasProfileImage) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inscription complétée avec succès.')),
    );
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
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    if (_showProfileImageError) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Veuillez importer une photo de profil',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      validator: _descriptionValidator,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: _submitStepTwo,
                        child: const Text('Terminer'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
