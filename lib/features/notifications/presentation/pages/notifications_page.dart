import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/data/repositories/supabase_deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_buyer_details_page.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_seller_details_page.dart';
import 'package:shareplace/features/profiles/data/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';

class ShareplaceNotification {
  const ShareplaceNotification({
    required this.id,
    required this.dealId,
    required this.title,
    required this.dealTitle,
    required this.senderFirstName,
    required this.imageUrl,
    required this.isUnread,
    required this.createdAt,
  });

  final String id;
  final String dealId;
  final String title;
  final String dealTitle;
  final String senderFirstName;
  final String imageUrl;
  final bool isUnread;
  final DateTime createdAt;
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    this.profileRepository,
    this.dealRepository,
    super.key,
  });

  final ProfileRepository? profileRepository;
  final DealRepository? dealRepository;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const _fallbackImageUrl =
      'https://picsum.photos/seed/shareplace-notification/120/120';

  late final ProfileRepository _profileRepository;
  late final DealRepository _dealRepository;

  String? _currentProfileId;
  List<ShareplaceNotification>? _notifications;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _profileRepository =
        widget.profileRepository ?? SupabaseProfileRepository();
    _dealRepository = widget.dealRepository ?? SupabaseDealRepository();
    unawaited(_loadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 28,
                        ),
                        onPressed: _goHome,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF841D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loadError != null) {
      return const Center(
        child: Text(
          'Impossible de charger les notifications.',
          style: TextStyle(color: Colors.black87),
        ),
      );
    }
    if (_notifications == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_notifications!.isEmpty) {
      return const Center(
        child: Text(
          'Aucune notification pour le moment.',
          style: TextStyle(color: Colors.black87),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _notifications!.length,
      separatorBuilder: (context, index) => const Divider(
        color: Color(0xFFEEEEEE),
        thickness: 1,
        height: 24,
      ),
      itemBuilder: (context, index) {
        final item = _notifications![index];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openDealFromNotification(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    item.imageUrl,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 75,
                        height: 75,
                        color: Colors.amber.shade700,
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.dealTitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.account_circle,
                            size: 18,
                            color: Color(0xFFFF841D),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'De ${item.senderFirstName}',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (item.isUnread)
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadNotifications() async {
    try {
      final currentProfile = await _profileRepository.getCurrentProfile();
      final currentProfileId = currentProfile?.id;
      if (!mounted) {
        return;
      }
      if (currentProfileId == null) {
        setState(() {
          _currentProfileId = null;
          _notifications = const [];
        });
        return;
      }

      final sellerDeals = await _dealRepository.getBySellerProfileId(
        currentProfileId,
      );
      final sellerDealIds = sellerDeals.map((deal) => deal.id).toList();
      final applicationsOnMyDeals = await _dealRepository
          .getApplicationsByDealIds(sellerDealIds);
      final myApplications = await _dealRepository
          .getApplicationsByApplicantProfileId(currentProfileId);

      final dealById = <String, Deal>{
        for (final deal in sellerDeals) deal.id: deal,
      };
      for (final application in myApplications) {
        if (!dealById.containsKey(application.dealId)) {
          try {
            final deal = await _dealRepository.getById(application.dealId);
            dealById[deal.id] = deal;
          } on Object {
            continue;
          }
        }
      }

      final profileIds = <String>{
        for (final application in applicationsOnMyDeals)
          application.applicantProfileId,
        for (final deal in dealById.values) deal.sellerProfileId,
      };
      final firstNameByProfileId = <String, String>{};
      for (final profileId in profileIds) {
        try {
          final profile = await _profileRepository.getById(profileId);
          firstNameByProfileId[profileId] = profile.firstName;
        } on Object {
          continue;
        }
      }

      final notifications = <ShareplaceNotification>[
        for (final application in applicationsOnMyDeals)
          if (dealById.containsKey(application.dealId))
            ShareplaceNotification(
              id: 'seller-${application.id}',
              dealId: application.dealId,
              title: 'Nouvelle demande de deal',
              dealTitle: dealById[application.dealId]!.title,
              senderFirstName:
                  firstNameByProfileId[application.applicantProfileId] ??
                  'Utilisateur',
              imageUrl: _fallbackImageUrl,
              isUnread: true,
              createdAt: application.createdAt,
            ),
        for (final application in myApplications)
          if (dealById.containsKey(application.dealId))
            ShareplaceNotification(
              id: 'buyer-${application.id}',
              dealId: application.dealId,
              title: 'Demande envoyée',
              dealTitle: dealById[application.dealId]!.title,
              senderFirstName:
                  firstNameByProfileId[dealById[application.dealId]!
                      .sellerProfileId] ??
                  'Vendeur',
              imageUrl: _fallbackImageUrl,
              isUnread: true,
              createdAt: application.createdAt,
            ),
      ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (!mounted) {
        return;
      }
      setState(() {
        _currentProfileId = currentProfileId;
        _notifications = notifications;
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

  Future<void> _openDealFromNotification(ShareplaceNotification item) async {
    try {
      final deal = await _dealRepository.getById(item.dealId);
      if (!mounted) {
        return;
      }
      final page = deal.sellerProfileId == _currentProfileId
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
    } on Object {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir l'offre.")),
      );
    }
  }

  void _goHome() {
    unawaited(
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.deals, (_) => false),
    );
  }
}
