import 'package:flutter/material.dart';
import 'package:shareplace/features/deals/domain/entities/my_deal_summary.dart';
import 'package:shareplace/features/deals/presentation/widgets/my_deal_status_chip.dart';

class MyDealCard extends StatelessWidget {
  const MyDealCard({
    required this.deal,
    this.onImageTap,
    super.key,
  });

  final MyDealSummary deal;
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context) {
    final colors = _roleColors(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: onImageTap,
                  borderRadius: BorderRadius.circular(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      deal.coverImageUrl,
                      width: 104,
                      height: 86,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 104,
                          height: 86,
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.image_outlined),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              deal.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        deal.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      MyDealStatusChip(deal: deal),
                    ],
                  ),
                ),
              ],
            ),
            if (deal.progress == MyDealProgress.sold &&
                deal.counterpartPhone != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${deal.role == MyDealRole.seller ? 'Acheteur' : 'Vendeur'} '
                  ': ${deal.counterpartPhone}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _RoleColors _roleColors(BuildContext context) {
    if (deal.role == MyDealRole.seller) {
      return const _RoleColors(
        background: Color(0xFFF1F8F5),
        border: Color(0xFF2F6F5E),
      );
    }

    return const _RoleColors(
      background: Color(0xFFFFF8EC),
      border: Color(0xFFD58A1F),
    );
  }
}

class _RoleColors {
  const _RoleColors({
    required this.background,
    required this.border,
  });

  final Color background;
  final Color border;
}
