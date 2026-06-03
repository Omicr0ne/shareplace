import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shareplace/features/product/data/products_data.dart';
import 'package:shareplace/features/product/presentation/widgets/product_image_carousel.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _picker = ImagePicker();

  final List<String> _tags = [];
  final List<Uint8List> _productImages = [];
  String? _selectedTag;
  bool _isImportingImages = false;
  bool _showImageError = false;

  @override
  void dispose() {
    _productController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickProductImages() async {
    if (_productImages.length >= ProductImageCarousel.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Limite atteinte: 5 images maximum par produit.'),
        ),
      );
      return;
    }

    setState(() {
      _isImportingImages = true;
    });

    try {
      final pickedFiles = await _picker.pickMultiImage(imageQuality: 85);
      if (!mounted) {
        return;
      }

      if (pickedFiles.isEmpty) {
        return;
      }

      final availableSlots = ProductImageCarousel.maxImages - _productImages.length;
      final filesToImport = pickedFiles.take(availableSlots).toList();
      final bytesList = await Future.wait(
        filesToImport.map((file) => file.readAsBytes()),
      );

      setState(() {
        _productImages.addAll(bytesList);
        _showImageError = false;
      });

      if (pickedFiles.length > availableSlots && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Seules 5 images maximum peuvent être ajoutées.'),
          ),
        );
      }
    } on Exception catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'importer les images pour le moment."),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isImportingImages = false;
        });
      }
    }
  }

  void _removeImageAt(int index) {
    setState(() {
      _productImages.removeAt(index);
      if (_productImages.isNotEmpty) {
        _showImageError = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
        ),
        title: const Text('Ajout Produit'),
        centerTitle: false,
        foregroundColor: const Color(0xFF3E2723),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Formulaire',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEF6C00),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5E9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFE0B2)),
                      ),
                      child: Column(
                        children: [
                          if (_productImages.isEmpty)
                            Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9F0),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFFFE0B2)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.image_outlined,
                                    size: 54,
                                    color: Color(0xFFEF6C00),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Ajouter des images',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '5 images maximum',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF8D6E63),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            SizedBox(
                              height: 220,
                              child: GridView.builder(
                                itemCount: _productImages.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.memory(
                                          _productImages[index],
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => _removeImageAt(index),
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE53935),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _isImportingImages ? null : _pickProductImages,
                              icon: _isImportingImages
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.photo_library_outlined),
                              label: Text(
                                _isImportingImages
                                    ? 'Import en cours...'
                                    : 'Importer depuis la galerie',
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFEF6C00),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${_productImages.length}/${ProductImageCarousel.maxImages} images sélectionnées',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF8D6E63),
                            ),
                          ),
                          if (_showImageError) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Veuillez ajouter au moins une image.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _TextFieldSection(
                      controller: _productController,
                      hintText: 'Produit',
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Nom du produit requis'
                              : null,
                    ),
                    const SizedBox(height: 10),
                    _TextFieldSection(
                      controller: _descriptionController,
                      hintText: 'Description',
                      maxLines: 4,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Description requise'
                              : null,
                    ),
                    const SizedBox(height: 10),
                    _TextFieldSection(
                      controller: _cityController,
                      hintText: 'Ville',
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Ville requise'
                              : null,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedTag,
                      isExpanded: true,
                      decoration: _inputDecoration('Tags'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Maison',
                          child: Text('Maison'),
                        ),
                        DropdownMenuItem(value: 'Déco', child: Text('Déco')),
                        DropdownMenuItem(
                          value: 'Cuisine',
                          child: Text('Cuisine'),
                        ),
                        DropdownMenuItem(
                          value: 'Jardin',
                          child: Text('Jardin'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null || _tags.contains(value)) {
                          return;
                        }

                        setState(() {
                          _selectedTag = value;
                          _addTag(value);
                        });
                      },
                      validator: (value) =>
                          value == null && _tags.isEmpty ? 'Tag requis' : null,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              backgroundColor: const Color(0xFFFFF3E0),
                              labelStyle: const TextStyle(
                                color: Color(0xFF3E2723),
                              ),
                              deleteIconColor: const Color(0xFFEF6C00),
                              onDeleted: () => _removeTag(tag),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF6C00),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Continuer'),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
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

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF8F9FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFE0B2)),
      ),
    );
  }

  void _addTag(String? value) {
    if (value == null || _tags.contains(value)) {
      return;
    }

    _tags.add(value);
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submit() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final hasImages = _productImages.isNotEmpty;

    setState(() {
      _showImageError = !hasImages;
    });

    if (!isFormValid || !hasImages) {
      return;
    }

    ProductsData.addProduct(
      article: _productController.text.trim(),
      vendeur: 'Moi',
      description: _descriptionController.text.trim(),
      ville: _cityController.text.trim(),
      tags: List<String>.from(_tags),
      images: List<Uint8List>.from(_productImages),
    );

    Navigator.pop(context, true);
  }
}

class _TextFieldSection extends StatelessWidget {
  const _TextFieldSection({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF8F9FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFE0B2)),
        ),
      ),
    );
  }
}
