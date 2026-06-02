import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/home/presentation/pages/home_page.dart';
import 'package:shareplace/features/my_deals/presentation/pages/my_deals_page.dart';
import 'package:shareplace/features/profile/presentation/pages/profile_page.dart';
import 'package:shareplace/features/welcome/presentation/pages/welcome_page.dart';

class SharePlaceApp extends StatelessWidget {
  const SharePlaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F6F5E),
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (_) => const WelcomePage(),
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.profile: (_) => const ProfilePage(),
        AppRoutes.myDeals: (_) => const MyDealsPage(),
      },
    );
  }
}
