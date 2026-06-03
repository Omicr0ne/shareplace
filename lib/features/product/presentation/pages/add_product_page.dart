import 'package:flutter/material.dart';
import 'package:shareplace/features/product/data/products_data.dart';

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

  final List<String> _tags = [];
  String? _selectedTag;

  @override
  void dispose() {
    _productController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    super.dispose();
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
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5E9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFE0B2)),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 54,
                            color: Color(0xFFEF6C00),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ajouter une image',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Fonctionnalité en développement',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8D6E63),
                            ),
                          ),
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
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    ProductsData.addProduct(
      article: _productController.text.trim(),
      vendeur: 'Moi',
      description: _descriptionController.text.trim(),
      ville: _cityController.text.trim(),
      tags: List<String>.from(_tags),
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
