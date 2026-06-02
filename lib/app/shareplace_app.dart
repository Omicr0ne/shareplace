import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/home/presentation/pages/home_page.dart';
import 'package:shareplace/features/legal_notices/presentation/pages/legal_notices_page.dart';
import 'package:shareplace/features/login/presentation/pages/forgot_password_page.dart';
import 'package:shareplace/features/login/presentation/pages/login_page.dart';
import 'package:shareplace/features/my_deals/presentation/pages/my_deals_page.dart';
import 'package:shareplace/features/notifications/presentation/pages/notifications_page.dart';
import 'package:shareplace/features/product/presentation/pages/add_product_page.dart';
import 'package:shareplace/features/profile/presentation/pages/account_verification_page.dart';
import 'package:shareplace/features/profile/presentation/pages/profile_page.dart';
import 'package:shareplace/features/register/presentation/pages/registration_page.dart';
import 'package:shareplace/features/report/presentation/pages/report_page.dart';
import 'package:shareplace/features/search/presentation/pages/search_with_filter_page.dart';
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
        AppRoutes.legalNotices: (_) => const LegalNoticesPage(),
        AppRoutes.notifications: (_) => const NotificationsPage(),
        AppRoutes.report: (_) => const ReportPage(),
        AppRoutes.profile: (_) => const ProfilePage(),
        AppRoutes.myDeals: (_) => const MyDealsPage(),
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.register: (_) => const RegistrationPage(),
        AppRoutes.addProduct: (_) => const AddProductPage(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
        AppRoutes.profileVerification: (_) => const AccountVerificationPage(),
        AppRoutes.search: (_) => const SearchWithFilterPage(),
      },
    );
  }
}
