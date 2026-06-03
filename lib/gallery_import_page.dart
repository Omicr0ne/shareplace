import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryImportPage extends StatefulWidget {
  const GalleryImportPage({super.key});

  static const routeName = '/gallery-import';

  @override
  State<GalleryImportPage> createState() => _GalleryImportPageState();
}

class _GalleryImportPageState extends State<GalleryImportPage> {
  final ImagePicker _picker = ImagePicker();
  final List<Uint8List> _images = <Uint8List>[];
  bool _isImporting = false;

  Future<void> _importFromGallery() async {
    setState(() {
      _isImporting = true;
    });

    try {
      final files = await _picker.pickMultiImage();
      if (files.isEmpty || !mounted) {
        return;
      }

      final bytesList = await Future.wait(
        files.map((file) => file.readAsBytes()),
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _images
          ..clear()
          ..addAll(bytesList);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
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
                    const _Header(),
                    const SizedBox(height: 24),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 44,
                          color: Color(0xFF707070),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Selectionnez une ou plusieurs images depuis votre '
                      'galerie.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF9F9F9F),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA500),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _isImporting ? null : _importFromGallery,
                      icon: _isImporting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(Icons.photo_library_outlined),
                      label: Text(
                        _isImporting
                            ? 'Import en cours...'
                            : 'Importer depuis la galerie',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (_images.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.collections_outlined,
                              color: Color(0xFFFFA500),
                              size: 30,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Aucune image importee',
                              style: TextStyle(color: Color(0xFFBDBDBD)),
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        height: 280,
                        child: GridView.builder(
                          itemCount: _images.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.memory(
                                _images[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
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

class _Header extends StatelessWidget {
  const _Header();

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
            'Importer images',
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
