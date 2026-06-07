import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/deals/presentation/widgets/deal_image_carousel.dart';

void main() {
  testWidgets('renders deal image URLs', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DealImageCarousel(
            dealTitle: 'Canape',
            imageUrls: ['https://example.com/deals/cover.png'],
          ),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<NetworkImage>());
  });
}
