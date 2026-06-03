import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/my_deals/domain/entities/my_deal_summary.dart';
import 'package:shareplace/features/my_deals/presentation/pages/my_deals_page.dart';

void main() {
  const longDescription =
      'Cette description volontairement très longue doit rester limitée à deux '
      'lignes dans la carte pour préserver la densité de la liste.';

  testWidgets('shows explicit deals and the empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyDealsPage(
          deals: [
            MyDealSummary(
              id: 'seller-pending',
              role: MyDealRole.seller,
              progress: MyDealProgress.pending,
              title: 'Chaise',
              description: 'Chaise simple en bon état.',
              coverImageUrl: 'https://example.com/chair.png',
              interestedCount: 1,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Mes offres'), findsOneWidget);
    expect(find.text('Chaise'), findsOneWidget);
    expect(find.text('1 intéressé'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: MyDealsPage(deals: [])));

    expect(find.text('Aucune offre en cours'), findsOneWidget);
  });

  testWidgets('shows status labels for seller and interested deals', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyDealsPage(
          deals: [
            MyDealSummary(
              id: 'two-interested',
              role: MyDealRole.seller,
              progress: MyDealProgress.pending,
              title: 'Lampe',
              description: 'Lampe de bureau fonctionnelle.',
              coverImageUrl: 'https://example.com/lamp.png',
              interestedCount: 2,
            ),
            MyDealSummary(
              id: 'seller-sold',
              role: MyDealRole.seller,
              progress: MyDealProgress.sold,
              title: 'Table',
              description: 'Table basse en bois.',
              coverImageUrl: 'https://example.com/table.png',
              counterpartPhone: '06 12 34 56 78',
            ),
            MyDealSummary(
              id: 'interested-pending',
              role: MyDealRole.interested,
              progress: MyDealProgress.pending,
              title: 'Micro-ondes',
              description: 'Micro-ondes fonctionnel.',
              coverImageUrl: 'https://example.com/microwave.png',
            ),
            MyDealSummary(
              id: 'interested-sold',
              role: MyDealRole.interested,
              progress: MyDealProgress.sold,
              title: 'Bureau',
              description: 'Bureau compact.',
              coverImageUrl: 'https://example.com/desk.png',
              counterpartPhone: '07 98 76 54 32',
            ),
          ],
        ),
      ),
    );

    expect(find.text('2 intéressés'), findsOneWidget);
    expect(find.text('Vendu'), findsOneWidget);
    expect(find.text('En attente'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Acquis'), 240);

    expect(find.text('Acquis'), findsOneWidget);
    expect(find.text('Acheteur : 06 12 34 56 78'), findsOneWidget);
    expect(find.text('Vendeur : 07 98 76 54 32'), findsOneWidget);
  });

  testWidgets('truncates long deal descriptions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyDealsPage(
          deals: [
            MyDealSummary(
              id: 'long-description',
              role: MyDealRole.seller,
              progress: MyDealProgress.pending,
              title: 'Description longue',
              description: longDescription,
              coverImageUrl: 'https://example.com/long.png',
            ),
          ],
        ),
      ),
    );

    final description = tester.widget<Text>(find.text(longDescription));

    expect(description.maxLines, 2);
    expect(description.overflow, TextOverflow.ellipsis);
  });
}
