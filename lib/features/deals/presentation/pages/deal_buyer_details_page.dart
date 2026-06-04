import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/core/widgets/share_button.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/deal_application.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/presentation/widgets/deal_image_carousel.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';

class DealBuyerDetailsPage extends StatefulWidget {
  const DealBuyerDetailsPage({
    required this.deal,
    required this.dealRepository,
    this.profileRepository,
    super.key,
  });

  final Deal deal;
  final DealRepository dealRepository;
  final ProfileRepository? profileRepository;

  @override
  State<DealBuyerDetailsPage> createState() => _DealBuyerDetailsPageState();
}

class _DealBuyerDetailsPageState extends State<DealBuyerDetailsPage> {
  late final ProfileRepository _profileRepository;

  String? _currentProfileId;
  bool _isInterested = false;
  DealApplicationStatus? _applicationStatus;
  bool _isLoadingInterest = true;
  bool _isSubmittingInterest = false;

  @override
  void initState() {
    super.initState();
    _profileRepository =
        widget.profileRepository ?? SupabaseProfileRepository();
    unawaited(_loadInterestState());
  }

  Future<void> _toggleInterest() async {
    if (_isSubmittingInterest || _currentProfileId == null) {
      return;
    }
    setState(() {
      _isSubmittingInterest = true;
    });
    try {
      if (_isInterested) {
        await widget.dealRepository.removeApplication(
          dealId: widget.deal.id,
          applicantProfileId: _currentProfileId!,
        );
      } else {
        await widget.dealRepository.addApplication(
          dealId: widget.deal.id,
          applicantProfileId: _currentProfileId!,
        );
      }
    } on Object {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de mettre à jour votre intérêt.'),
        ),
      );
      setState(() {
        _isSubmittingInterest = false;
      });
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _isInterested = !_isInterested;
      _applicationStatus = _isInterested ? null : DealApplicationStatus.pending;
      _isSubmittingInterest = false;
    });
  }

  Future<void> _loadInterestState() async {
    try {
      final profile = await _profileRepository.getCurrentProfile();
      final profileId = profile?.id;
      if (!mounted) {
        return;
      }
      if (profileId == null) {
        setState(() {
          _isLoadingInterest = false;
        });
        return;
      }
      final applications = await widget.dealRepository
          .getApplicationsByApplicantProfileId(profileId);
      final application = applications
          .cast<DealApplicationRecord?>()
          .firstWhere(
            (application) => application?.dealId == widget.deal.id,
            orElse: () => null,
          );
      final isInterested =
          application?.status == DealApplicationStatus.pending ||
          application?.status == DealApplicationStatus.accepted;
      if (!mounted) {
        return;
      }
      setState(() {
        _currentProfileId = profileId;
        _isInterested = isInterested;
        _applicationStatus = application?.status;
        _isLoadingInterest = false;
      });
    } on Object {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingInterest = false;
      });
    }
  }

  String _shareText(Deal deal) {
    return 'Découvrez cette annonce sur SharePlace : ${deal.title}\n'
        'Code postal : ${deal.postalCode}\n\n'
        '${deal.description}';
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;
    final maxAvailable = deal.maxWinnerCount;
    final isFood = deal.isFoodSupply;

    final interestText = _interestButtonText;

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
                  DealImageCarousel(
                    dealTitle: deal.title,
                    images: const [],
                  ),
                  const SizedBox(height: 16),
                  // ── Badge denrée alimentaire ─────────────────────────────
                  if (isFood) ...[
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
                  // ── Localisation (code postal) ───────────────────────────
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
                  // ── Nombre de lots disponibles ──────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 18,
                        color: Color(0xFFEF6C00),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$maxAvailable lot${maxAvailable > 1 ? 's' : ''} '
                        'disponible${maxAvailable > 1 ? 's' : ''}',
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
                              Navigator.pushNamed(
                                context,
                                '/reports/create',
                                arguments: {
                                  'reportedProfileId': deal.sellerProfileId,
                                  'dealId': deal.id,
                                },
                              ),
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
                        'Annonce du vendeur',
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
                  // ── Bouton intérêt ───────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          (_isLoadingInterest || _isSubmittingInterest) ||
                              !_canToggleInterest
                          ? null
                          : _toggleInterest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isInterested
                            ? const Color(0xFFFFB74D)
                            : const Color(0xFFEF6C00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: Text(interestText),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Vous pouvez changer d'avis à tout moment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8D6E63),
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

  String get _interestButtonText {
    return switch (_applicationStatus) {
      DealApplicationStatus.accepted => 'Demande acceptée',
      DealApplicationStatus.rejected => 'Demande refusée',
      DealApplicationStatus.cancelled => 'Je suis intéressé',
      DealApplicationStatus.pending => 'Je ne suis plus intéressé',
      null => 'Je suis intéressé',
    };
  }

  bool get _canToggleInterest {
    return _applicationStatus == null ||
        _applicationStatus == DealApplicationStatus.pending ||
        _applicationStatus == DealApplicationStatus.cancelled;
  }
}
