import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';

void main() {
  group('Deal', () {
    test('maps Supabase json to Deal', () {
      final deal = Deal.fromJson({
        'id': 'deal-id',
        'seller_profile_id': 'seller-id',
        'title': 'Canapé convertible',
        'description': 'Canapé deux places en bon état.',
        'postal_code': '69001',
        'max_winner_count': 2,
        'state': 'closed',
        'is_food_supply': true,
        'created_at': '2026-01-01T09:00:00.000Z',
        'updated_at': '2026-01-03T09:00:00.000Z',
      });

      expect(deal.id, 'deal-id');
      expect(deal.sellerProfileId, 'seller-id');
      expect(deal.maxWinnerCount, 2);
      expect(deal.state, DealState.closed);
      expect(deal.isFoodSupply, isTrue);
    });

    test('maps Deal to Supabase json', () {
      final deal = Deal(
        id: 'deal-id',
        sellerProfileId: 'seller-id',
        title: 'Canapé convertible',
        description: 'Canapé deux places en bon état.',
        postalCode: '69001',
        maxWinnerCount: 2,
        isFoodSupply: true,
        createdAt: DateTime.parse('2026-01-01T09:00:00.000Z'),
        updatedAt: DateTime.parse('2026-01-03T09:00:00.000Z'),
      );

      expect(deal.toJson(), {
        'id': 'deal-id',
        'seller_profile_id': 'seller-id',
        'title': 'Canapé convertible',
        'description': 'Canapé deux places en bon état.',
        'postal_code': '69001',
        'max_winner_count': 2,
        'state': 'open',
        'is_food_supply': true,
        'created_at': '2026-01-01T09:00:00.000Z',
        'updated_at': '2026-01-03T09:00:00.000Z',
      });
    });

    test('omits null timestamps from Supabase insert json', () {
      final deal = Deal(
        id: '',
        sellerProfileId: 'seller-id',
        title: 'Canapé convertible',
        description: 'Canapé deux places en bon état.',
        postalCode: '69001',
      );

      expect(deal.toJson(), isNot(contains('created_at')));
      expect(deal.toJson(), isNot(contains('updated_at')));
    });

    test('rejects invalid deal constraints', () {
      expect(
        () => Deal(
          id: 'deal-id',
          sellerProfileId: 'seller-id',
          title: 'Ok',
          description: 'Description correcte.',
          postalCode: '69001',
        ),
        throwsArgumentError,
      );
    });
  });

  group('DealApplicationRecord', () {
    test('stores application status', () {
      final record = DealApplicationRecord(
        id: 'application-id',
        dealId: 'deal-id',
        applicantProfileId: 'buyer-id',
        status: DealApplicationStatus.accepted,
        createdAt: DateTime.parse('2026-01-01T09:00:00.000Z'),
      );

      expect(record.status, DealApplicationStatus.accepted);
    });
  });
}
