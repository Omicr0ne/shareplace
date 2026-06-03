import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/core/widgets/share_button.dart';
import 'package:shareplace/features/product/domain/entities/product_item.dart';
import 'package:shareplace/features/product/presentation/pages/add_product_page.dart';
import 'package:shareplace/features/product/presentation/pages/product_buyer_details_page.dart';
import 'package:shareplace/features/product/presentation/pages/product_seller_details_page.dart';

void main() {
  const product = ProductItem(
    id: 4242,
    article: 'Canape vintage',
    vendeur: 'Steve',
    description: 'Canape confortable en bon etat.',
    ville: 'Lyon',
    tags: ['Maison', 'Deco'],
  );

  testWidgets('product detail pages expose share buttons', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProductBuyerDetailsPage(product: product)),
    );

    expect(find.byType(ShareButton), findsOneWidget);
    expect(find.text(product.article), findsWidgets);

    await tester.pumpWidget(
      const MaterialApp(home: ProductSellerDetailsPage(product: product)),
    );

    expect(find.byType(ShareButton), findsOneWidget);
    expect(find.text(product.article), findsWidgets);
  });

  testWidgets('buyer can toggle interest in a product', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProductBuyerDetailsPage(product: product)),
    );

    expect(find.text('Je suis intéressé'), findsOneWidget);

    await tester.tap(find.text('Je suis intéressé'));
    await tester.pump();

    expect(find.text('Je ne suis plus intéressé'), findsOneWidget);
  });

  testWidgets('add product validates required fields', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddProductPage()));

    await tester.scrollUntilVisible(
      find.text('Continuer'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Continuer'));
    await tester.pump();

    expect(find.text('Nom du produit requis'), findsOneWidget);
    expect(find.text('Description requise'), findsOneWidget);
    expect(find.text('Ville requise'), findsOneWidget);
    expect(find.text('Tag requis'), findsOneWidget);
  });
}
