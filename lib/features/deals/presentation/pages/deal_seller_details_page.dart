import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/core/widgets/share_button.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/deal_application.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/presentation/widgets/deal_image_carousel.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';

class DealSellerDetailsPage extends StatefulWidget {
  const DealSellerDetailsPage({
    required this.deal,
    required this.dealRepository,
    this.profileRepository,
    super.key,
  });

  final Deal deal;
  final DealRepository dealRepository;
  final ProfileRepository? profileRepository;

  @override
  State<DealSellerDetailsPage> createState() => _DealSellerDetailsPageState();
}

class _DealSellerDetailsPageState extends State<DealSellerDetailsPage> {
  late final ProfileRepository _profileRepository;

  // Deal local — mis à jour après chaque acceptation pour refléter
  // le maxWinnerCount décrémenté sans recharger toute la page.
  late Deal _deal;

  List<_ApplicationView>? _applications;
  Object? _applicationsError;
  bool _isUpdatingApplication = false;

  @override
  void initState() {
    super.initState();
    _deal = widget.deal;
    _profileRepository =
        widget.profileRepository ?? SupabaseProfileRepository();
    unawaited(_loadApplications());
  }

  String _shareText(Deal deal) {
    return 'Découvrez cette annonce sur SharePlace : ${deal.title}\n'
        'Code postal : ${deal.postalCode}\n\n'
        '${deal.description}';
  }

  Future<void> _cancelDeal() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Supprimer l'annonce ?"),
          content: const Text(
            'Cette action est définitive et annulera votre offre.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF6C00),
                foregroundColor: Colors.white,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await widget.dealRepository.cancel(widget.deal.id);
    if (!mounted) return;

    Navigator.pop(context, true);
  }

  Future<void> _loadApplications() async {
    try {
      final applications = await widget.dealRepository.getApplicationsByDealIds(
        [_deal.id],
      );
      final views = <_ApplicationView>[];
      for (final application in applications) {
        try {
          final profile = await _profileRepository.getById(
            application.applicantProfileId,
          );
          views.add(
            _ApplicationView(application: application, profile: profile),
          );
        } on Object {
          views.add(_ApplicationView(application: application));
        }
      }
      if (!mounted) return;
      setState(() {
        _applications = views;
        _applicationsError = null;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _applicationsError = error;
      });
    }
  }

  /// Accepte ou refuse une candidature.
  /// Si acceptation : décrémente maxWinnerCount.
  /// Si maxWinnerCount atteint 0 : ferme le deal.
  Future<void> _decideApplication(
    DealApplicationRecord application, {
    required bool accept,
  }) async {
    if (_isUpdatingApplication) return;
    setState(() {
      _isUpdatingApplication = true;
    });

    try {
      if (accept) {
        await widget.dealRepository.acceptApplication(application.id);
        await _decrementLots();
      } else {
        await widget.dealRepository.rejectApplication(application.id);
      }
      await _loadApplications();
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de traiter la demande.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingApplication = false;
        });
      }
    }
  }

  /// Décrémente maxWinnerCount de 1.
  /// Si le compteur atteint 0 → ferme le deal via cancel().
  Future<void> _decrementLots() async {
    final newCount = _deal.maxWinnerCount - 1;

    if (newCount <= 0) {
      await widget.dealRepository.cancel(_deal.id);
      if (!mounted) return;
      // Retourne true pour que la home recharge la liste.
      Navigator.pop(context, true);
      return;
    }

    final updated = await widget.dealRepository.update(
      _deal.copyWith(maxWinnerCount: newCount),
    );
    if (!mounted) return;
    setState(() {
      _deal = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deal = _deal;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
        ),
        actions: [
          ShareButton(
            title: deal.title,
            subject: 'Annonce SharePlace : ${deal.title}',
            text: _shareText(deal),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Titre ────────────────────────────────────────────────
                  Align(
                    child: Text(
                      deal.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFEF6C00),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // ── Carousel d'images ────────────────────────────────────
                  DealImageCarousel(dealTitle: deal.title, images: const []),
                  const SizedBox(height: 16),
                  // ── Badge denrée alimentaire ─────────────────────────────
                  if (deal.isFoodSupply) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 16,
                            color: Colors.green.shade800,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Denrée alimentaire',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // ── Code postal ──────────────────────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Color(0xFFEF6C00),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          deal.postalCode,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // ── Nombre de lots restants ──────────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 18,
                        color: Color(0xFFEF6C00),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${deal.maxWinnerCount} '
                        'lot${deal.maxWinnerCount > 1 ? 's' : ''} '
                        'restant${deal.maxWinnerCount > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ── En-tête description ──────────────────────────────────
                  Row(
                    children: [
                      Material(
                        color: const Color(0xFFEF6C00),
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            unawaited(
                              Navigator.pushNamed(context, '/profile'),
                            );
                          },
                          child: const SizedBox(
                            width: 36,
                            height: 36,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Vous publiez cette annonce',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    deal.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // ── Bouton suppression ───────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _cancelDeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF6C00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: const Text("Supprimer l'annonce"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // ── Liste des candidatures ───────────────────────────────
                  _ApplicationsSection(
                    applications: _applications,
                    hasError: _applicationsError != null,
                    isUpdating: _isUpdatingApplication,
                    onAccept: (application) => _decideApplication(
                      application,
                      accept: true,
                    ),
                    onReject: (application) => _decideApplication(
                      application,
                      accept: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Section candidatures ─────────────────────────────────────────────────────

class _ApplicationsSection extends StatelessWidget {
  const _ApplicationsSection({
    required this.applications,
    required this.hasError,
    required this.isUpdating,
    required this.onAccept,
    required this.onReject,
  });

  final List<_ApplicationView>? applications;
  final bool hasError;
  final bool isUpdating;
  final ValueChanged<DealApplicationRecord> onAccept;
  final ValueChanged<DealApplicationRecord> onReject;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acheteurs intéressés',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF3E2723),
          ),
        ),
        const SizedBox(height: 12),
        if (hasError)
          const Text('Impossible de charger les demandes.')
        else if (applications == null)
          const Center(child: CircularProgressIndicator())
        else if (applications!.isEmpty)
          const Text('Aucun acheteur intéressé pour le moment.')
        else
          for (final view in applications!) ...[
            _ApplicationTile(
              view: view,
              isUpdating: isUpdating,
              onAccept: onAccept,
              onReject: onReject,
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _ApplicationTile extends StatelessWidget {
  const _ApplicationTile({
    required this.view,
    required this.isUpdating,
    required this.onAccept,
    required this.onReject,
  });

  final _ApplicationView view;
  final bool isUpdating;
  final ValueChanged<DealApplicationRecord> onAccept;
  final ValueChanged<DealApplicationRecord> onReject;

  @override
  Widget build(BuildContext context) {
    final application = view.application;
    final isPending = application.status == DealApplicationStatus.pending;
    final isAccepted = application.status == DealApplicationStatus.accepted;
    final phone = view.profile?.phone;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCC80)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              view.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _statusLabel(application.status),
              style: const TextStyle(color: Color(0xFF6D4C41)),
            ),
            // ── Numéro de l'acheteur (visible uniquement si accepté) ──────
            if (isAccepted && phone != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    size: 16,
                    color: Color(0xFFEF6C00),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    phone,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                ],
              ),
            ],
            if (isAccepted && phone == null) ...[
              const SizedBox(height: 8),
              const Text(
                'Numéro non renseigné',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8D6E63),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            // ── Boutons accepter / refuser (pending uniquement) ───────────
            if (isPending) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isUpdating
                          ? null
                          : () => onReject(application),
                      child: const Text('Refuser'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isUpdating
                          ? null
                          : () => onAccept(application),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF6C00),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Accepter'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _statusLabel(DealApplicationStatus status) {
    return switch (status) {
      DealApplicationStatus.pending => 'En attente de décision',
      DealApplicationStatus.accepted => 'Acceptée',
      DealApplicationStatus.rejected => 'Refusée',
      DealApplicationStatus.cancelled => 'Annulée',
    };
  }
}

class _ApplicationView {
  const _ApplicationView({required this.application, this.profile});

  final DealApplicationRecord application;
  final Profile? profile;

  String get displayName {
    final profile = this.profile;
    if (profile == null) return 'Acheteur';
    return '${profile.firstName} ${profile.lastName}';
  }
}
