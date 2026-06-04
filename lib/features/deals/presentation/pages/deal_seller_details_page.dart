import 'package:flutter/material.dart';
import 'package:shareplace/core/widgets/share_button.dart';
import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/presentation/widgets/deal_image_carousel.dart';

class DealSellerDetailsPage extends StatefulWidget {
  const DealSellerDetailsPage({
    required this.deal,
    required this.dealRepository,
    super.key,
  });

  final Deal deal;
  final DealRepository dealRepository;

  @override
  State<DealSellerDetailsPage> createState() => _DealSellerDetailsPageState();
}

class _DealSellerDetailsPageState extends State<DealSellerDetailsPage> {
  String _shareText(Deal deal) {
    return 'Découvrez cette annonce sur SharePlace : ${deal.title}\n'
        'Code postal : ${deal.postalCode}\n\n'
        '${deal.description}';
  }

  Future<void> _cancelDeal() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Supprimer l'annonce ?"),
          content: const Text(
            'Cette action est définitive et annulera votre offre.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF6C00),
                foregroundColor: Colors.white,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await widget.dealRepository.cancel(widget.deal.id);
    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;

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
                  DealImageCarousel(
                    dealTitle: deal.title,
                    images: const [],
                  ),
                  const SizedBox(height: 16),
                  // ── Badge denrée alimentaire ─────────────────────────────
                  if (deal.isFoodSupply) ...[
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
                  // ── Code postal ──────────────────────────────────────────
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
                  // ── Nombre de lots ───────────────────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 18,
                        color: Color(0xFFEF6C00),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${deal.maxWinnerCount} '
                        'lot${deal.maxWinnerCount > 1 ? 's' : ''} '
                        'disponible${deal.maxWinnerCount > 1 ? 's' : ''}',
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
                        'Vous publiez cette annonce',
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
                  // ── Bouton suppression ───────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _cancelDeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF6C00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: const Text("Supprimer l'annonce"),
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
