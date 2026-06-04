import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/data/repositories/deal_tag_repository.dart';
import 'package:shareplace/features/deals/data/repositories/supabase_deal_tag_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/presentation/widgets/deal_image_carousel.dart';
import 'package:shareplace/features/profiles/data/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';

class CreateDealPage extends StatefulWidget {
  const CreateDealPage({
    required this.dealRepository,
    this.profileRepository,
    this.dealTagRepository,
    this.initialProductImages = const [],
    super.key,
  });

  final DealRepository dealRepository;
  final ProfileRepository? profileRepository;
  final DealTagRepository? dealTagRepository;
  final List<Uint8List> initialProductImages;

  @override
  State<CreateDealPage> createState() => _CreateDealPageState();
}

class _CreateDealPageState extends State<CreateDealPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _maxWinnerController = TextEditingController(text: '1');
  final _picker = ImagePicker();

  final List<String> _tags = [];
  final List<Uint8List> _productImages = [];
  String? _selectedTag;
  bool _isImportingImages = false;
  bool _showImageError = false;
  bool _isFoodSupply = false;
  bool _isSubmitting = false;
  List<String>? _availableTags;

  late final ProfileRepository _profileRepository =
      widget.profileRepository ?? SupabaseProfileRepository();
  late final DealTagRepository _dealTagRepository =
      widget.dealTagRepository ?? SupabaseDealTagRepository();

  @override
  void initState() {
    super.initState();
    _productImages.addAll(
      widget.initialProductImages.take(DealImageCarousel.maxImages),
    );
    unawaited(_loadAvailableTags());
  }

  Future<void> _loadAvailableTags() async {
    try {
      final tags = await _dealTagRepository.getAvailableTags();
      if (!mounted) {
        return;
      }
      setState(() {
        _availableTags = tags;
      });
    } on Object catch (error) {
      debugPrint('Erreur lors du chargement des tags : $error');
      if (!mounted) {
        return;
      }
      setState(() {
        _availableTags = const [];
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _postalCodeController.dispose();
    _maxWinnerController.dispose();
    super.dispose();
  }

  Future<void> _pickProductImages() async {
    if (_productImages.length >= DealImageCarousel.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Limite atteinte: 5 images maximum par offre.'),
        ),
      );
      return;
    }

    setState(() {
      _isImportingImages = true;
    });

    try {
      final pickedFiles = await _picker.pickMultiImage(imageQuality: 85);
      if (!mounted) return;
      if (pickedFiles.isEmpty) return;

      final availableSlots =
          DealImageCarousel.maxImages - _productImages.length;
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
      if (!mounted) return;
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
    const productImageGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    );

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
        title: const Text("Ajout d'offre"),
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
                    // ── Section images ──────────────────────────────────────
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
                                border: Border.all(
                                  color: const Color(0xFFFFE0B2),
                                ),
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
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
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
                                gridDelegate: productImageGridDelegate,
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
                              onPressed: _isImportingImages
                                  ? null
                                  : _pickProductImages,
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${_productImages.length}/${DealImageCarousel.maxImages} images sélectionnées',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: const Color(0xFF8D6E63)),
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
                    // ── Titre (= title dans Deal) ───────────────────────────
                    _TextFieldSection(
                      controller: _titleController,
                      hintText: "Titre de l'offre",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Titre requis';
                        }
                        if (value.trim().length < 3 ||
                            value.trim().length > 120) {
                          return 'Entre 3 et 120 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // ── Description ────────────────────────────────────────
                    _TextFieldSection(
                      controller: _descriptionController,
                      hintText: 'Description',
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description requise';
                        }
                        if (value.trim().length < 10 ||
                            value.trim().length > 2000) {
                          return 'Entre 10 et 2000 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // ── Code postal (= postalCode dans Deal) ───────────────
                    _TextFieldSection(
                      controller: _postalCodeController,
                      hintText: 'Code postal',
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Code postal requis'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    // ── Nombre de lots (= maxWinnerCount dans Deal) ─────────
                    _TextFieldSection(
                      controller: _maxWinnerController,
                      hintText: 'Nombre de lots disponibles',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nombre de lots requis';
                        }
                        final n = int.tryParse(value.trim());
                        if (n == null || n < 1) {
                          return 'Doit être un entier ≥ 1';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // ── Denrée alimentaire (= isFoodSupply dans Deal) ───────
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFE0B2)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: SwitchListTile(
                          title: const Text(
                            "Il s'agit de nourriture",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3E2723),
                            ),
                          ),
                          subtitle: const Text(
                            'Denrée alimentaire',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8D6E63),
                            ),
                          ),
                          value: _isFoodSupply,
                          activeThumbColor: const Color(0xFFEF6C00),
                          onChanged: (value) {
                            setState(() {
                              _isFoodSupply = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // ── Tags ───────────────────────────────────────────────
                    DropdownButtonFormField<String>(
                      initialValue: _selectedTag,
                      isExpanded: true,
                      decoration: _inputDecoration('Tags'),
                      items: (_availableTags ?? const <String>[])
                          .map(
                            (tag) => DropdownMenuItem(
                              value: tag,
                              child: Text(tag),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null || _tags.contains(value)) return;
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
                    // ── Bouton soumettre ───────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
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

  void _addTag(String value) {
    if (_tags.contains(value)) return;
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

    if (!isFormValid || !hasImages) return;

    unawaited(_submitDeal());
  }

  Future<void> _submitDeal() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final currentProfile = await _profileRepository.getCurrentProfile();
      if (currentProfile == null) {
        throw StateError('Pas de profil utilisateur trouvé.');
      }
      final maxWinners = int.tryParse(_maxWinnerController.text.trim()) ?? 1;

      final deal = Deal(
        id: '',
        sellerProfileId: currentProfile.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        maxWinnerCount: maxWinners,
        isFoodSupply: _isFoodSupply,
      );

      //soucis de gestion des tags (Mise en place d'une excemption pour
      //isoler l'erreur de tag et ne pas bloquer la création du deal)
      // 1. Création de l'offre
      final createdDeal = await widget.dealRepository.create(deal);

      // 2. Ajout des tags (sécurisé dans un sous-try-catch pour
      //isoler l'erreur)
      try {
        await _dealTagRepository.setTagsForDeal(createdDeal.id, _tags);
      } on Object catch (tagError) {
        // On affiche l'erreur des tags dans la console sans bloquer la
        //validation du deal
        debugPrint('Erreur lors de l’association des tags : $tagError');
      }

      //A faire(team): ajouter l'upload des images dans Supabase Storage
      //et associer les URLs retournées à l'offre créée

      if (!mounted) return;
      Navigator.pop(context, true);
    } on Object catch (e) {
      // Affichage de l'erreur globale si la création de
      //l'offre elle-même échoue
      debugPrint('Échec de la création complète du deal : $e');

      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible de créer l'offre pour le moment."),
        ),
      );
    }
  }
}

class _TextFieldSection extends StatelessWidget {
  const _TextFieldSection({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      keyboardType: keyboardType,
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
