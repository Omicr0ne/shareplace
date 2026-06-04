import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/core/widgets/app_header.dart';
import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/data/repositories/supabase_deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/my_deal_summary.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_buyer_details_page.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_seller_details_page.dart';
import 'package:shareplace/features/deals/presentation/widgets/my_deal_card.dart';
import 'package:shareplace/features/profiles/data/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';

class MyDealsPage extends StatefulWidget {
  const MyDealsPage({
    this.deals,
    this.profileRepository,
    this.dealRepository,
    super.key,
  });

  final List<MyDealSummary>? deals;
  final ProfileRepository? profileRepository;
  final DealRepository? dealRepository;

  @override
  State<MyDealsPage> createState() => _MyDealsPageState();
}

class _MyDealsPageState extends State<MyDealsPage> {
  static const _fallbackCoverImageUrl =
      'https://picsum.photos/seed/shareplace-deal/240/160';

  late final ProfileRepository _profileRepository;
  late final DealRepository _dealRepository;
  List<MyDealSummary>? _loadedDeals;
  Object? _loadError;

  bool get _usesExplicitDeals => widget.deals != null;

  @override
  void initState() {
    super.initState();
    _profileRepository =
        widget.profileRepository ?? SupabaseProfileRepository();
    _dealRepository = widget.dealRepository ?? SupabaseDealRepository();

    if (!_usesExplicitDeals) {
      unawaited(_loadMyDeals());
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleDeals = widget.deals ?? _loadedDeals;
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
                if (_loadError != null)
                  const _MyDealsErrorState()
                else if (visibleDeals == null)
                  const Center(child: CircularProgressIndicator())
                else if (visibleDeals.isEmpty)
                  const _EmptyMyDealsState()
                else
                  for (final deal in visibleDeals) ...[
                    MyDealCard(
                      deal: deal,
                      onImageTap: () => _openDealDetails(deal),
                    ),
                    const SizedBox(height: 16),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadMyDeals() async {
    try {
      final profile = await _profileRepository.getCurrentProfile();
      if (!mounted) {
        return;
      }
      if (profile == null) {
        unawaited(
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.signIn, (_) => false),
        );
        return;
      }

      final deals = await _dealRepository.getBySellerProfileId(profile.id);
      final myApplications = await _dealRepository
          .getApplicationsByApplicantProfileId(profile.id);
      var interestedCountByDeal = const <String, int>{};
      try {
        interestedCountByDeal = await _dealRepository
            .countApplicationsByDealIds(
              deals.map((deal) => deal.id).toList(growable: false),
            );
      } on Object {
        // Keep the page usable even when deal_applications is unavailable.
        interestedCountByDeal = const {};
      }
      if (!mounted) {
        return;
      }

      final interestedDeals = <MyDealSummary>[];
      for (final application in myApplications) {
        try {
          final deal = await _dealRepository.getById(application.dealId);
          if (deal.sellerProfileId == profile.id) {
            continue;
          }
          interestedDeals.add(_toInterestedSummary(deal, application));
        } on Object {
          continue;
        }
      }

      setState(() {
        _loadedDeals = [
          for (final deal in deals)
            _toSellerSummary(
              deal,
              interestedCount: interestedCountByDeal[deal.id] ?? 0,
            ),
          ...interestedDeals,
        ];
      });
    } on Object catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loadError = error;
      });
    }
  }

  MyDealSummary _toSellerSummary(Deal deal, {required int interestedCount}) {
    return MyDealSummary(
      id: deal.id,
      role: MyDealRole.seller,
      progress: deal.state == DealState.closed
          ? MyDealProgress.sold
          : MyDealProgress.pending,
      title: deal.title,
      description: deal.description,
      coverImageUrl: _fallbackCoverImageUrl,
      interestedCount: interestedCount,
    );
  }

  MyDealSummary _toInterestedSummary(
    Deal deal,
    DealApplicationRecord application,
  ) {
    return MyDealSummary(
      id: deal.id,
      role: MyDealRole.interested,
      progress: _progressForApplication(application.status),
      title: deal.title,
      description: deal.description,
      coverImageUrl: _fallbackCoverImageUrl,
    );
  }

  MyDealProgress _progressForApplication(DealApplicationStatus status) {
    return switch (status) {
      DealApplicationStatus.pending => MyDealProgress.pending,
      DealApplicationStatus.accepted => MyDealProgress.sold,
      DealApplicationStatus.rejected => MyDealProgress.rejected,
      DealApplicationStatus.cancelled => MyDealProgress.cancelled,
    };
  }

  Future<void> _openDealDetails(MyDealSummary summary) async {
    try {
      final profile = await _profileRepository.getCurrentProfile();
      final deal = await _dealRepository.getById(summary.id);
      if (!mounted) {
        return;
      }

      final page = deal.sellerProfileId == profile?.id
          ? DealSellerDetailsPage(
              deal: deal,
              dealRepository: _dealRepository,
              profileRepository: _profileRepository,
            )
          : DealBuyerDetailsPage(
              deal: deal,
              dealRepository: _dealRepository,
              profileRepository: _profileRepository,
            );

      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (context) => page));
    } on Object {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir l'offre.")),
      );
    }
  }

  void _goHome(BuildContext context) {
    unawaited(
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.deals, (_) => false),
    );
  }
}

class _MyDealsErrorState extends StatelessWidget {
  const _MyDealsErrorState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Impossible de charger vos offres',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
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
