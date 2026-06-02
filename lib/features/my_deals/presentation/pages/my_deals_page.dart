import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/core/widgets/app_header.dart';
import 'package:shareplace/features/my_deals/data/my_deals_placeholders.dart';
import 'package:shareplace/features/my_deals/domain/entities/my_deal_summary.dart';
import 'package:shareplace/features/my_deals/presentation/widgets/my_deal_card.dart';

class MyDealsPage extends StatelessWidget {
  const MyDealsPage({
    this.deals,
    super.key,
  });

  final List<MyDealSummary>? deals;

  @override
  Widget build(BuildContext context) {
    final visibleDeals = deals ?? myDealsPlaceholders;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
              children: [
                AppHeader(
                  title: 'Mes offres',
                  onBack: () => _goHome(context),
                ),
                const SizedBox(height: 24),
                if (visibleDeals.isEmpty)
                  const _EmptyMyDealsState()
                else
                  for (final deal in visibleDeals) ...[
                    MyDealCard(deal: deal),
                    const SizedBox(height: 16),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goHome(BuildContext context) {
    unawaited(
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
    );
  }
}

class _EmptyMyDealsState extends StatelessWidget {
  const _EmptyMyDealsState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune offre en cours',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
