import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormulairePage extends StatelessWidget {
  const FormulairePage({super.key});

  static const routeName = '/formulaire';

  @override
  Widget build(BuildContext context) {
    return const _FormulaireScaffold();
  }
}

class FormulaireImagePickerPage extends StatefulWidget {
  const FormulaireImagePickerPage({super.key});

  static const routeName = '/formulaire-image-picker';

  @override
  State<FormulaireImagePickerPage> createState() =>
      _FormulaireImagePickerPageState();
}

class _FormulaireImagePickerPageState extends State<FormulaireImagePickerPage> {
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _selectedImage;

  Future<void> _pickImage() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }

    final bytes = await file.readAsBytes();
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedImage = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _FormulaireScaffold(
      selectedImage: _selectedImage,
      onImageAreaTap: _pickImage,
      actionLabel: 'Choisir une image',
      helperText: kIsWeb
          ? 'Version ImagePicker active sur web et desktop.'
          : 'Version ImagePicker active sur mobile et desktop.',
    );
  }
}

class _FormulaireScaffold extends StatelessWidget {
  const _FormulaireScaffold({
    this.selectedImage,
    this.onImageAreaTap,
    this.actionLabel = 'Ouvrir la galerie',
    this.helperText = 'Simulation galerie via bottom sheet.',
  });

  final Uint8List? selectedImage;
  final VoidCallback? onImageAreaTap;
  final String actionLabel;
  final String helperText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF151515),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 24,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _FormulaireHeader(),
                    const SizedBox(height: 28),
                    _ImageBox(
                      imageBytes: selectedImage,
                      onTap: onImageAreaTap,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      helperText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF9F9F9F),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _StyledTextField(
                      label: 'Produit',
                      hintText: 'Nom du produit',
                    ),
                    const SizedBox(height: 16),
                    const _StyledTextField(
                      label: 'Description',
                      hintText: 'Decrivez votre annonce',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    const _StyledTextField(
                      label: 'Localisation',
                      hintText: 'Ville ou quartier',
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA500),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _showGallerySheet(context),
                      child: Text(
                        actionLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
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

  Future<void> _showGallerySheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF2B2B2B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: SizedBox(
              height: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A6A6A),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Galerie',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      itemCount: 12,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF454545),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_outlined,
                                color: Color(0xFFFFA500),
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Photo ${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FormulaireHeader extends StatelessWidget {
  const _FormulaireHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          const Text(
            'Formulaire',
            style: TextStyle(
              color: Color(0xFFFFA500),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  const _ImageBox({this.imageBytes, this.onTap});

  final Uint8List? imageBytes;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFD9D9D9),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: 120,
          child: Center(
            child: imageBytes == null
                ? const Icon(
                    Icons.image,
                    size: 44,
                    color: Color(0xFF707070),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.memory(
                      imageBytes!,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.label,
    required this.hintText,
    this.maxLines = 1,
  });

  final String label;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF7A7A7A)),
            filled: true,
            fillColor: const Color(0xFFE9E9E9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFFFA500),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
