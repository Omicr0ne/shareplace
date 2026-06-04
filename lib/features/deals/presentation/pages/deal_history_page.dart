import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/deals/data/repositories/supabase_deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_buyer_details_page.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_seller_details_page.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    this.dealRepository,
    this.profileRepository,
    super.key,
  });

  final DealRepository? dealRepository;
  final ProfileRepository? profileRepository;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const _fallbackImageUrl =
      'https://picsum.photos/seed/shareplace-history/300/200';

  late final DealRepository _dealRepository;
  late final ProfileRepository _profileRepository;
  Future<_HistoryData>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _dealRepository = widget.dealRepository ?? SupabaseDealRepository();
    _profileRepository =
        widget.profileRepository ?? SupabaseProfileRepository();
    _historyFuture = _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Historique',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF841D),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goHome,
          tooltip: 'Retour à l’accueil',
        ),
      ),
      body: FutureBuilder<_HistoryData>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Impossible de charger l’historique.'),
            );
          }

          final historyData = snapshot.data;
          final deals = historyData?.deals ?? const <Deal>[];
          if (deals.isEmpty) {
            return const Center(
              child: Text('Aucune annonce dans l’historique.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: deals.length,
            itemBuilder: (context, index) {
              final deal = deals[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildHistoryCard(
                  deal: deal,
                  currentProfileId: historyData?.currentProfileId,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<_HistoryData> _loadHistory() async {
    final currentProfile = await _profileRepository.getCurrentProfile();
    if (currentProfile == null) {
      return const _HistoryData(deals: []);
    }

    final sellerDeals = await _dealRepository.getBySellerProfileId(
      currentProfile.id,
    );
    final closedDeals =
        sellerDeals
            .where((deal) => deal.state == DealState.closed)
            .toList(growable: false)
          ..sort((a, b) {
            final aDate = a.updatedAt ?? a.createdAt ?? DateTime(1970);
            final bDate = b.updatedAt ?? b.createdAt ?? DateTime(1970);
            return bDate.compareTo(aDate);
          });

    return _HistoryData(
      deals: closedDeals,
      currentProfileId: currentProfile.id,
    );
  }

  Widget _buildHistoryCard({
    required Deal deal,
    required String? currentProfileId,
  }) {
    final formattedDate = _formatDate(deal.updatedAt ?? deal.createdAt);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _openDealDetails(deal, currentProfileId),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFFF841D),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                deal.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _fallbackImageUrl,
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 100,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, color: Colors.white),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    deal.description,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 100),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_box,
                    color: Color(0xFF00B25C),
                    size: 24,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '($formattedDate)',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDealDetails(Deal deal, String? currentProfileId) async {
    final page = deal.sellerProfileId == currentProfileId
        ? DealSellerDetailsPage(
            deal: deal,
            dealRepository: _dealRepository,
          )
        : DealBuyerDetailsPage(
            deal: deal,
            dealRepository: _dealRepository,
          );
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => page));
  }

  void _goHome() {
    unawaited(
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.deals, (_) => false),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return '--/--/----';
    }
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }
}

class _HistoryData {
  const _HistoryData({
    required this.deals,
    this.currentProfileId,
  });

  final List<Deal> deals;
  final String? currentProfileId;
}
