import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/auth/data/auth_service.dart';
import 'package:shareplace/features/deals/data/repositories/supabase_deal_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_buyer_details_page.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_seller_details_page.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/presentation/widgets/profile_logout_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  late final ProfileRepository _profileRepository;
  late final DealRepository _dealRepository;
  Future<_HomeData>? _homeDataFuture;

  @override
  void initState() {
    super.initState();
    _profileRepository = SupabaseProfileRepository();
    _dealRepository = SupabaseDealRepository();
    _homeDataFuture = _loadHomeData();
  }

  Future<_HomeData> _loadHomeData() async {
    final currentProfile = await _profileRepository.getCurrentProfile();
    final deals = await _dealRepository.getOpenDeals();
    return _HomeData(
      deals: deals,
      currentProfileId: currentProfile?.id,
    );
  }

  Future<void> _openAddDealPage() async {
    final currentProfileId = (await _homeDataFuture)?.currentProfileId ?? '';
    if (!mounted) {
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      AppRoutes.createDeal,
      arguments: {
        'dealRepository': _dealRepository,
        'sellerProfileId': currentProfileId,
      },
    );

    if (result == true && mounted) {
      setState(() {
        _homeDataFuture = _loadHomeData();
      });
    }
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

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    if (result == true && mounted) {
      setState(() {
        _homeDataFuture = _loadHomeData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEF6C00), Color(0xFFFFB74D)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.home_outlined,
                      color: Color(0xFFEF6C00),
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Accueil'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.waving_hand_outlined),
              title: const Text('Bienvenue'),
              onTap: () {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(context, AppRoutes.welcome),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(context, AppRoutes.profile),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: const Text('Créer une offre'),
              onTap: () async {
                Navigator.pop(context);
                await _openAddDealPage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.price_change_outlined),
              title: const Text('Mes offres'),
              onTap: () async {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(context, AppRoutes.myDeals),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history_outlined),
              title: const Text('Historique des offres'),
              onTap: () async {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.dealHistory,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              onTap: () async {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.notifications,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel_outlined),
              title: const Text('Mentions légales'),
              onTap: () async {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.legalNotices,
                  ),
                );
              },
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ProfileLogoutButton(onPressed: _showSignOutConfirmation),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('SharePlace'),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.person_outline),
            tooltip: 'Menu profil',
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<_HomeData>(
          future: _homeDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Impossible de charger les offres.',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final homeData = snapshot.data;
            final deals = homeData?.deals ?? const <Deal>[];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: TextField(
                    onTap: () => _showComingSoon(context),
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Rechercher une offre',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                    itemCount: deals.length,
                    itemBuilder: (context, index) {
                      final deal = deals[index];
                      return _DealCard(
                        deal: deal,
                        onTap: () => _openDealDetails(
                          deal,
                          homeData?.currentProfileId,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDealPage,
        backgroundColor: const Color(0xFFEF6C00),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  static void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('En développement.')),
    );
  }

  Future<void> _showSignOutConfirmation() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Confirmer la déconnexion ?'),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                unawaited(_signOut());
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (!mounted) {
      return;
    }

    unawaited(
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.signIn, (_) => false),
    );
  }
}

class _DealCard extends StatelessWidget {
  const _DealCard({
    required this.deal,
    required this.onTap,
  });

  final Deal deal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
                  ),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 44,
                        color: Color(0xFF8D6E63),
                      ),
                    ),
                    if (deal.isFoodSupply)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deal.postalCode,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  if (deal.maxWinnerCount > 1) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${deal.maxWinnerCount} lots',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFEF6C00),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeData {
  const _HomeData({
    required this.deals,
    required this.currentProfileId,
  });

  final List<Deal> deals;
  final String? currentProfileId;
}
