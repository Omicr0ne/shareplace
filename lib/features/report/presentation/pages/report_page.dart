import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/profiles/domain/entities/profile.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({
    this.reportedProfileId,
    this.dealId,
    this.profileRepository,
    this.client,
    super.key,
  });

  final String? reportedProfileId;
  final String? dealId;
  final ProfileRepository? profileRepository;
  final SupabaseClient? client;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _motifController = TextEditingController();
  late final ProfileRepository _profileRepository;
  bool _isSubmitting = false;
  Profile? _targetProfile;
  bool _isLoadingTargetProfile = false;

  @override
  void initState() {
    super.initState();
    _profileRepository =
        widget.profileRepository ?? SupabaseProfileRepository();
    if (widget.reportedProfileId != null &&
        widget.reportedProfileId!.isNotEmpty) {
      unawaited(_loadTargetProfile(widget.reportedProfileId!));
    }
  }

  @override
  void dispose() {
    _motifController.dispose();
    super.dispose();
  }

  SupabaseClient _client() {
    if (widget.client != null) {
      return widget.client!;
    }
    return Supabase.instance.client;
  }

  Future<void> _loadTargetProfile(String profileId) async {
    setState(() {
      _isLoadingTargetProfile = true;
    });
    try {
      final profile = await _profileRepository.getById(profileId);
      if (!mounted) return;
      setState(() {
        _targetProfile = profile;
        _isLoadingTargetProfile = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _isLoadingTargetProfile = false;
      });
    }
  }

  Future<void> _validerSignalement() async {
    final motifSaisi = _motifController.text.trim();
    if (motifSaisi.isEmpty) {
      _showError('Veuillez saisir un motif avant de valider.');
      return;
    }
    if (widget.reportedProfileId == null || widget.reportedProfileId!.isEmpty) {
      _showError('Impossible de déterminer le profil à signaler.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final reporter = await _profileRepository.getCurrentProfile();
      if (reporter == null) {
        throw StateError('Aucun profil courant.');
      }
      await _insertReport(
        reporterProfileId: reporter.id,
        reportedProfileId: widget.reportedProfileId!,
        dealId: widget.dealId,
        motif: motifSaisi,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signalement envoyé.'),
          backgroundColor: Color(0xFFFF841D),
        ),
      );
      Navigator.pop(context);
    } on PostgrestException catch (error) {
      if (!mounted) return;
      _showError('Échec en base: ${error.message}');
      setState(() {
        _isSubmitting = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      _showError('Échec de l’envoi: $error');
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _insertReport({
    required String reporterProfileId,
    required String reportedProfileId,
    required String motif,
    String? dealId,
  }) async {
    final client = _client();
    final targetDealField = dealId == null
        ? null
        : <String, Object?>{'target_deal_id': dealId};

    final payloads = <Map<String, Object?>>[
      {
        'reporter_profile_id': reporterProfileId,
        'target_profile_id': reportedProfileId,
        ...?targetDealField,
        'title': 'Signalement utilisateur',
        'description': motif,
        'state': 'open',
      },
      {
        'reporter_profile_id': reporterProfileId,
        'target_profile_id': reportedProfileId,
        ...?targetDealField,
        'title': 'Signalement utilisateur',
        'description': motif,
        'state': 'pending',
      },
      {
        'reporter_profile_id': reporterProfileId,
        'target_profile_id': reportedProfileId,
        ...?targetDealField,
        'title': 'Signalement utilisateur',
        'description': motif,
      },
    ];

    PostgrestException? lastPostgrestError;
    for (final payload in payloads) {
      try {
        await client.from('reports').insert(payload);
        return;
      } on PostgrestException catch (error) {
        lastPostgrestError = error;
      }
    }

    if (lastPostgrestError != null) {
      throw lastPostgrestError;
    }
    throw StateError('Impossible d’insérer le signalement.');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Signaler un profil',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF841D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey.shade400,
                      backgroundImage: _targetProfile?.profilePictureUrl != null
                          ? NetworkImage(_targetProfile!.profilePictureUrl!)
                          : null,
                      child: _targetProfile?.profilePictureUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 90,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (_isLoadingTargetProfile)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    Text(
                      _targetProfile == null
                          ? 'Profil signalé'
                          : 'A propos de ${_targetProfile!.firstName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _buildTargetProfileDescription(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  TextField(
                    controller: _motifController,
                    maxLines: null,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Motif',
                      hintStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF2F4FF),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _validerSignalement,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF841D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Valider',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  String _buildTargetProfileDescription() {
    final profile = _targetProfile;
    if (profile == null) {
      return 'Impossible de charger les informations du profil signalé.';
    }

    final location = profile.postalCode?.trim();
    final description = profile.description.trim();
    final header = location == null || location.isEmpty
        ? '${profile.firstName} ${profile.lastName}'
        : '${profile.firstName} ${profile.lastName} · $location';

    if (description.isEmpty) {
      return header;
    }
    return '$header\n$description';
  }
}
