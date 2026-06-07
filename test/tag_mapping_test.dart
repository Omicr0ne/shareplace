import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/deals/domain/entities/deal_tag.dart';

void main() {
  group('DealTag', () {
    test('normalizes labels for Supabase uniqueness', () {
      expect(DealTag.normalizeLabel(' Souris '), 'souris');
      expect(DealTag.normalizeLabel('Déco maison'), 'deco maison');
    });
  });
}
