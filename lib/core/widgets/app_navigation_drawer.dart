import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/auth/data/auth_service.dart';
import 'package:shareplace/features/profiles/presentation/widgets/profile_logout_button.dart';

class AppNavigationItem {
  const AppNavigationItem({
    required this.route,
    required this.title,
    required this.icon,
  });

  final String route;
  final String title;
  final IconData icon;
}

const appNavigationItems = [
  AppNavigationItem(
    route: AppRoutes.deals,
    title: 'Accueil',
    icon: Icons.home_outlined,
  ),
  AppNavigationItem(
    route: AppRoutes.welcome,
    title: 'Bienvenue',
    icon: Icons.waving_hand_outlined,
  ),
  AppNavigationItem(
    route: AppRoutes.profile,
    title: 'Profil',
    icon: Icons.person_outline,
  ),
  AppNavigationItem(
    route: AppRoutes.createDeal,
    title: 'Créer une offre',
    icon: Icons.add_box_outlined,
  ),
  AppNavigationItem(
    route: AppRoutes.myDeals,
    title: 'Mes offres',
    icon: Icons.price_change_outlined,
  ),
  AppNavigationItem(
    route: AppRoutes.dealHistory,
    title: 'Historique des offres',
    icon: Icons.history_outlined,
  ),
  AppNavigationItem(
    route: AppRoutes.notifications,
    title: 'Notifications',
    icon: Icons.notifications_outlined,
  ),
  AppNavigationItem(
    route: AppRoutes.legalNotices,
    title: 'Mentions légales',
    icon: Icons.gavel_outlined,
  ),
];

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({
    required this.currentRoute,
    this.authService,
    super.key,
  });

  final String currentRoute;
  final AuthService? authService;

  @override
  Widget build(BuildContext context) {
    final currentItem = _itemForRoute(currentRoute) ?? appNavigationItems.first;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            key: const Key('app-drawer-header'),
            decoration: const BoxDecoration(
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
                    currentItem.icon,
                    key: const Key('app-drawer-header-icon'),
                    color: const Color(0xFFEF6C00),
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  currentItem.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          for (final item in appNavigationItems) ...[
            if (item.route == AppRoutes.profile) const Divider(height: 1),
            ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              selected: item.route == currentRoute,
              onTap: () => _navigate(context, item.route),
            ),
          ],
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ProfileLogoutButton(
              onPressed: () => unawaited(_showSignOutConfirmation(context)),
            ),
          ),
        ],
      ),
    );
  }

  AppNavigationItem? _itemForRoute(String route) {
    for (final item in appNavigationItems) {
      if (item.route == route) {
        return item;
      }
    }
    return null;
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    if (route == currentRoute) {
      return;
    }
    unawaited(Navigator.pushReplacementNamed(context, route));
  }

  Future<void> _showSignOutConfirmation(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Confirmer la déconnexion ?'),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                unawaited(_signOut(context));
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await (authService ?? AuthService()).signOut();
    if (!context.mounted) {
      return;
    }

    unawaited(
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.signIn, (_) => false),
    );
  }
}
