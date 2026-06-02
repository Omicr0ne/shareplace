import 'package:flutter/material.dart';
import 'package:shareplace/features/my_deals/domain/entities/my_deal_summary.dart';

class MyDealStatusChip extends StatelessWidget {
  const MyDealStatusChip({
    required this.deal,
    super.key,
  });

  final MyDealSummary deal;

  @override
  Widget build(BuildContext context) {
    final status = _status;
    return Align(
      key: const Key('my-deal-status-align'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 18),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  _DealStatusView get _status {
    if (deal.progress == MyDealProgress.sold) {
      return _DealStatusView(
        icon: Icons.shopping_cart_outlined,
        label: deal.role == MyDealRole.seller ? 'Vendu' : 'Acquis',
      );
    }

    if (deal.role == MyDealRole.seller) {
      final pluralSuffix = deal.interestedCount > 1 ? 's' : '';
      return _DealStatusView(
        icon: Icons.visibility_outlined,
        label: '${deal.interestedCount} intéressé$pluralSuffix',
      );
    }

    return const _DealStatusView(
      icon: Icons.hourglass_empty,
      label: 'En attente',
    );
  }
}

class _DealStatusView {
  const _DealStatusView({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}
