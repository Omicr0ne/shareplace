import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/app/app_theme.dart';
import 'package:shareplace/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:shareplace/features/auth/presentation/pages/sign_in_page.dart';
import 'package:shareplace/features/auth/presentation/pages/sign_up_page.dart';
import 'package:shareplace/features/auth/presentation/pages/welcome_page.dart';
import 'package:shareplace/features/deals/data/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/data/repositories/supabase_deal_repository.dart';
import 'package:shareplace/features/deals/presentation/pages/create_deal_page.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_history_page.dart';
import 'package:shareplace/features/deals/presentation/pages/my_deals_page.dart';
import 'package:shareplace/features/home/presentation/pages/home_page.dart';
import 'package:shareplace/features/legal_notices/presentation/pages/legal_notices_page.dart';
import 'package:shareplace/features/notifications/presentation/pages/notifications_page.dart';
import 'package:shareplace/features/profile/presentation/pages/account_verification_page.dart';
import 'package:shareplace/features/profile/presentation/pages/profile_page.dart';
import 'package:shareplace/features/report/presentation/pages/report_page.dart';
import 'package:shareplace/features/search/presentation/pages/search_with_filter_page.dart';

class SharePlaceApp extends StatelessWidget {
  const SharePlaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (_) => const WelcomePage(),
        AppRoutes.deals: (_) => const HomePage(),
        AppRoutes.legalNotices: (_) => const LegalNoticesPage(),
        AppRoutes.notifications: (_) => const NotificationsPage(),
        AppRoutes.createReport: (_) => const ReportPage(),
        AppRoutes.profile: (_) => const ProfilePage(),
        AppRoutes.myDeals: (_) => const MyDealsPage(),
        AppRoutes.signIn: (_) => const SignInPage(),
        AppRoutes.signUp: (_) => const SignUpPage(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
        AppRoutes.studentVerification: (_) => const AccountVerificationPage(),
        AppRoutes.search: (_) => const SearchWithFilterPage(),
        AppRoutes.dealHistory: (_) => const HistoryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.createDeal) {
          final args = settings.arguments as Map<String, dynamic>?;

          final dealRepository =
              args?['dealRepository'] as DealRepository? ??
              SupabaseDealRepository();
          final sellerProfileId = args?['sellerProfileId'] as String? ?? '';

          return MaterialPageRoute<bool>(
            settings: settings,
            builder: (_) => CreateDealPage(
              dealRepository: dealRepository,
              sellerProfileId: sellerProfileId,
            ),
          );
        }

        return null;
      },
    );
  }
}
