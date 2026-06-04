import 'package:flutter/material.dart';
import 'package:shareplace/core/widgets/share_button.dart';
import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/presentation/widgets/deal_image_carousel.dart';

class DealBuyerDetailsPage extends StatefulWidget {
  const DealBuyerDetailsPage({
    required this.deal,
    required this.dealRepository,
    super.key,
  });

  final Deal deal;
  final DealRepository dealRepository;

  @override
  State<DealBuyerDetailsPage> createState() => _DealBuyerDetailsPageState();
}

class _DealBuyerDetailsPageState extends State<DealBuyerDetailsPage> {
  // État local d'intérêt — à connecter à ton système de candidatures.
  bool _isInterested = false;
  int _selectedQuantity = 1;

  Future<void> _toggleInterest() async {
    // Local state until deal_applications is wired to Supabase.
    setState(() {
      _isInterested = !_isInterested;
    });
  }

  String _shareText(Deal deal) {
    return 'Découvrez cette annonce sur SharePlace : ${deal.title}\n'
        'Code postal : ${deal.postalCode}\n\n'
        '${deal.description}';
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;
    final maxAvailable = deal.maxWinnerCount;
    final isFood = deal.isFoodSupply;

    final interestText = _isInterested
        ? 'Je ne suis plus intéressé'
        : 'Je suis intéressé';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
        ),
        actions: [
          ShareButton(
            title: deal.title,
            subject: 'Annonce SharePlace : ${deal.title}',
            text: _shareText(deal),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Titre ────────────────────────────────────────────────
                  Align(
                    child: Text(
                      deal.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFEF6C00),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // ── Carousel d'images ────────────────────────────────────
                  // Les images sont gérées séparément (stockage fichiers).
                  // Passe ici la liste d'URLs/bytes quand tu les as.
                  DealImageCarousel(
                    dealTitle: deal.title,
                    images: const [],
                  ),
                  const SizedBox(height: 16),
                  // ── Badge denrée alimentaire ─────────────────────────────
                  if (isFood) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 16,
                            color: Colors.green.shade800,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Denrée alimentaire',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // ── Localisation (code postal) ───────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Color(0xFFEF6C00),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          deal.postalCode,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // ── Nombre de lots disponibles ──────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 18,
                        color: Color(0xFFEF6C00),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$maxAvailable lot${maxAvailable > 1 ? 's' : ''} '
                        'disponible${maxAvailable > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ── En-tête description ──────────────────────────────────
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFEF6C00),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Annonce du vendeur',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    deal.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // ── Sélecteur de quantité ────────────────────────────────
                  if (maxAvailable > 1 && !_isInterested) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Quantité souhaitée :',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        DropdownButton<int>(
                          value: _selectedQuantity,
                          dropdownColor: const Color(0xFFF7F4EF),
                          items: List.generate(maxAvailable, (i) => i + 1)
                              .map(
                                (qty) => DropdownMenuItem(
                                  value: qty,
                                  child: Text('$qty'),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedQuantity = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  // ── Bouton intérêt ───────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _toggleInterest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isInterested
                            ? const Color(0xFFFFB74D)
                            : const Color(0xFFEF6C00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        _isInterested
                            ? interestText
                            : '$interestText ($_selectedQuantity)',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Vous pouvez changer d'avis à tout moment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8D6E63),
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
