import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/auth/data/auth_service.dart';
import 'package:shareplace/features/deals/data/repositories/supabase_deal_repository.dart';
import 'package:shareplace/features/deals/data/repositories/supabase_deal_tag_repository.dart';
import 'package:shareplace/features/deals/domain/entities/deal.dart';
import 'package:shareplace/features/deals/domain/entities/deal_search_filters.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_tag_repository.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_buyer_details_page.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_seller_details_page.dart';
import 'package:shareplace/features/profiles/data/repositories/supabase_profile_repository.dart';
import 'package:shareplace/features/profiles/domain/repositories/profile_repository.dart';
import 'package:shareplace/features/profiles/presentation/widgets/profile_logout_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    this.profileRepository,
    this.dealRepository,
    this.dealTagRepository,
    super.key,
  });

  final ProfileRepository? profileRepository;
  final DealRepository? dealRepository;
  final DealTagRepository? dealTagRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  final _searchController = TextEditingController();
  final _postalCodeController = TextEditingController();
  late final ProfileRepository _profileRepository;
  late final DealRepository _dealRepository;
  late final DealTagRepository _dealTagRepository;
  Future<_HomeData>? _homeDataFuture;
  Future<List<String>>? _availableTagsFuture;
  bool? _isFoodSupplyFilter;
  List<String> _selectedTags = const [];

  @override
  void initState() {
    super.initState();
    _profileRepository =
        widget.profileRepository ?? SupabaseProfileRepository();
    _dealRepository = widget.dealRepository ?? SupabaseDealRepository();
    _dealTagRepository =
        widget.dealTagRepository ?? SupabaseDealTagRepository();
    _homeDataFuture = _loadHomeData();
    _availableTagsFuture = _loadAvailableTags();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<_HomeData> _loadHomeData() async {
    final currentProfile = await _profileRepository.getCurrentProfile();
    final deals = await _dealRepository.searchOpenDeals(
      DealSearchFilters(
        query: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        postalCode: _postalCodeController.text.trim().isEmpty
            ? null
            : _postalCodeController.text.trim(),
        isFoodSupply: _isFoodSupplyFilter,
        tags: _selectedTags,
      ),
    );
    return _HomeData(
      deals: deals,
      currentProfileId: currentProfile?.id,
    );
  }

  Future<List<String>> _loadAvailableTags() async {
    try {
      return await _dealTagRepository.getAvailableTags();
    } on Object {
      return const [];
    }
  }

  void _reloadDeals() {
    setState(() {
      _homeDataFuture = _loadHomeData();
    });
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
                _HomeSearchBar(
                  controller: _searchController,
                  hasActiveFilters:
                      _postalCodeController.text.trim().isNotEmpty ||
                      _isFoodSupplyFilter != null ||
                      _selectedTags.isNotEmpty,
                  onSearch: _reloadDeals,
                  onOpenFilters: _showFilters,
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

  Future<void> _showFilters() async {
    final availableTags =
        await (_availableTagsFuture ?? Future.value(<String>[]));
    if (!mounted) {
      return;
    }

    final result = await showModalBottomSheet<_HomeFilters>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return _HomeFiltersSheet(
          availableTags: availableTags,
          initialPostalCode: _postalCodeController.text,
          initialIsFoodSupply: _isFoodSupplyFilter,
          initialTags: _selectedTags,
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    _postalCodeController.text = result.postalCode;
    _isFoodSupplyFilter = result.isFoodSupply;
    _selectedTags = result.tags;
    _reloadDeals();
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

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar({
    required this.controller,
    required this.hasActiveFilters,
    required this.onSearch,
    required this.onOpenFilters,
  });

  final TextEditingController controller;
  final bool hasActiveFilters;
  final VoidCallback onSearch;
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key('home-search-field'),
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              decoration: InputDecoration(
                hintText: 'Rechercher une offre',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  key: const Key('home-search-submit'),
                  tooltip: 'Rechercher',
                  onPressed: onSearch,
                  icon: const Icon(Icons.arrow_forward),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            key: const Key('home-filter-button'),
            tooltip: 'Filtres',
            onPressed: onOpenFilters,
            icon: Badge(
              isLabelVisible: hasActiveFilters,
              child: const Icon(Icons.tune),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeFilters {
  const _HomeFilters({
    required this.postalCode,
    required this.isFoodSupply,
    required this.tags,
  });

  final String postalCode;
  final bool? isFoodSupply;
  final List<String> tags;
}

class _HomeFiltersSheet extends StatefulWidget {
  const _HomeFiltersSheet({
    required this.availableTags,
    required this.initialPostalCode,
    required this.initialIsFoodSupply,
    required this.initialTags,
  });

  final List<String> availableTags;
  final String initialPostalCode;
  final bool? initialIsFoodSupply;
  final List<String> initialTags;

  @override
  State<_HomeFiltersSheet> createState() => _HomeFiltersSheetState();
}

class _HomeFiltersSheetState extends State<_HomeFiltersSheet> {
  late final TextEditingController _postalCodeController;
  late bool _onlyFoodSupply;
  late final Set<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _postalCodeController = TextEditingController(
      text: widget.initialPostalCode,
    );
    _onlyFoodSupply = widget.initialIsFoodSupply ?? false;
    _selectedTags = widget.initialTags.toSet();
  }

  @override
  void dispose() {
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtres',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('home-postal-code-filter'),
              controller: _postalCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Code postal',
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              key: const Key('home-food-filter'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Afficher uniquement les dons alimentaires'),
              value: _onlyFoodSupply,
              onChanged: (value) {
                setState(() {
                  _onlyFoodSupply = value;
                });
              },
            ),
            if (widget.availableTags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.availableTags
                    .map((tag) {
                      return FilterChip(
                        label: Text(tag),
                        selected: _selectedTags.contains(tag),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag);
                            } else {
                              _selectedTags.remove(tag);
                            }
                          });
                        },
                      );
                    })
                    .toList(growable: false),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                        const _HomeFilters(
                          postalCode: '',
                          isFoodSupply: null,
                          tags: [],
                        ),
                      );
                    },
                    child: const Text('Réinitialiser'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    key: const Key('home-apply-filters'),
                    onPressed: () {
                      Navigator.of(context).pop(
                        _HomeFilters(
                          postalCode: _postalCodeController.text.trim(),
                          isFoodSupply: _onlyFoodSupply ? true : null,
                          tags: _selectedTags.toList(growable: false),
                        ),
                      );
                    },
                    child: const Text('Appliquer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
