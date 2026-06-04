import 'dart:typed_data';

import 'package:flutter/material.dart';

class DealImageCarousel extends StatefulWidget {
  const DealImageCarousel({
    required this.dealTitle,
    required this.images,
    super.key,
  });

  final String dealTitle;
  final List<Uint8List> images;

  static const int maxImages = 5;

  @override
  State<DealImageCarousel> createState() => _DealImageCarouselState();
}

class _DealImageCarouselState extends State<DealImageCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  static const List<_CarouselSlide> _placeholderSlides = [
    _CarouselSlide(
      mainColor: Color(0xFFFFE0B2),
      accentColor: Color(0xFFFFCC80),
      icon: Icons.weekend_outlined,
    ),
    _CarouselSlide(
      mainColor: Color(0xFFFFF3E0),
      accentColor: Color(0xFFFFE0B2),
      icon: Icons.inventory_2_outlined,
    ),
    _CarouselSlide(
      mainColor: Color(0xFFFFEBD6),
      accentColor: Color(0xFFFFD59E),
      icon: Icons.image_outlined,
    ),
    _CarouselSlide(
      mainColor: Color(0xFFFFF4E5),
      accentColor: Color(0xFFFFE0B2),
      icon: Icons.photo_library_outlined,
    ),
    _CarouselSlide(
      mainColor: Color(0xFFFFF0D9),
      accentColor: Color(0xFFFFD59E),
      icon: Icons.collections_outlined,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayImages = widget.images
        .take(DealImageCarousel.maxImages)
        .toList();
    final hasImages = displayImages.isNotEmpty;

    return Column(
      children: [
        Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: hasImages
                  ? displayImages.length
                  : _placeholderSlides.length,
              itemBuilder: (context, index) {
                if (hasImages) {
                  return _CarouselImageView(
                    imageBytes: displayImages[index],
                    dealTitle: widget.dealTitle,
                    position: index + 1,
                    total: displayImages.length,
                  );
                }

                final slide = _placeholderSlides[index];
                return _CarouselSlideView(
                  slide: slide,
                  dealTitle: widget.dealTitle,
                  position: index + 1,
                  total: _placeholderSlides.length,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            hasImages ? displayImages.length : _placeholderSlides.length,
            (index) {
              final selected = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: selected ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFEF6C00)
                      : const Color(0xFFFFCC80),
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CarouselSlide {
  const _CarouselSlide({
    required this.mainColor,
    required this.accentColor,
    required this.icon,
  });

  final Color mainColor;
  final Color accentColor;
  final IconData icon;
}

class _CarouselSlideView extends StatelessWidget {
  const _CarouselSlideView({
    required this.slide,
    required this.dealTitle,
    required this.position,
    required this.total,
  });

  final _CarouselSlide slide;
  final String dealTitle;
  final int position;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [slide.mainColor, slide.accentColor],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$position/$total',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3E2723),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  slide.icon,
                  size: 72,
                  color: const Color(0xFF8D6E63),
                ),
                const SizedBox(height: 10),
                Text(
                  dealTitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselImageView extends StatelessWidget {
  const _CarouselImageView({
    required this.imageBytes,
    required this.dealTitle,
    required this.position,
    required this.total,
  });

  final Uint8List imageBytes;
  final String dealTitle;
  final int position;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.memory(
            imageBytes,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.22),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$position/$total',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3E2723),
              ),
            ),
          ),
        ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              dealTitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3E2723),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
