import 'package:flutter/material.dart';
import 'package:shareplace/core/fixtures/products_data.dart';
import 'package:shareplace/core/widgets/product_image_carousel.dart';

class InfoProductClient extends StatefulWidget {
  const InfoProductClient({super.key, required this.product});

  final ProductItem product;

  @override
  State<InfoProductClient> createState() => _InfoProductClientState();
}

class _InfoProductClientState extends State<InfoProductClient> {
  bool get _isInterested => ProductsData.isInterested(widget.product.id);

  Future<void> _toggleInterest() async {
    setState(() {
      ProductsData.toggleInterest(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final interestText = _isInterested ? 'Je ne suis plus intéressé' : 'Je suis intéressé';

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
        actions: const [
          Icon(Icons.share_outlined),
          SizedBox(width: 16),
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
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      product.article,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFEF6C00),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ProductImageCarousel(productTitle: product.article),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Color(0xFFEF6C00)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          product.ville,
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
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: const Color(0xFFFFF3E0),
                            labelStyle: const TextStyle(color: Color(0xFF3E2723)),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFEF6C00),
                        child: Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
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
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _toggleInterest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isInterested ? const Color(0xFFFFB74D) : const Color(0xFFEF6C00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: Text(interestText),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Vous pouvez changer d\'avis à tout moment.',
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
