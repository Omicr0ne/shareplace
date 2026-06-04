import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/app/app_theme.dart';
import 'package:shareplace/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:shareplace/features/auth/presentation/pages/sign_in_page.dart';
import 'package:shareplace/features/auth/presentation/pages/sign_up_page.dart';
import 'package:shareplace/features/auth/presentation/pages/welcome_page.dart';
import 'package:shareplace/features/deals/data/repositories/supabase_deal_repository.dart';
import 'package:shareplace/features/deals/domain/repositories/deal_repository.dart';
import 'package:shareplace/features/deals/presentation/pages/create_deal_page.dart';
import 'package:shareplace/features/deals/presentation/pages/deal_history_page.dart';
import 'package:shareplace/features/deals/presentation/pages/my_deals_page.dart';
import 'package:shareplace/features/home/presentation/pages/home_page.dart';
import 'package:shareplace/features/legal_notices/presentation/pages/legal_notices_page.dart';
import 'package:shareplace/features/notifications/presentation/pages/notifications_page.dart';
import 'package:shareplace/features/profiles/presentation/pages/account_verification_page.dart';
import 'package:shareplace/features/profiles/presentation/pages/profile_page.dart';
import 'package:shareplace/features/report/presentation/pages/report_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef AuthenticatedCheck = bool Function();

class SharePlaceApp extends StatelessWidget {
  const SharePlaceApp({
    AuthenticatedCheck? isAuthenticated,
    super.key,
    // Keep a public named parameter `isAuthenticated` for widget tests.
    // ignore: prefer_initializing_formals
  }) : _isAuthenticated = isAuthenticated;

  final AuthenticatedCheck? _isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: (settings) {
        if (!_isPublicRoute(settings.name) && !_hasAuthenticatedSession()) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const SignInPage(),
          );
        }

        if (settings.name == AppRoutes.createDeal) {
          final args = settings.arguments as Map<String, dynamic>?;

          final dealRepository =
              args?['dealRepository'] as DealRepository? ??
              SupabaseDealRepository();

          return MaterialPageRoute<bool>(
            settings: settings,
            builder: (_) => CreateDealPage(
              dealRepository: dealRepository,
            ),
          );
        }

        if (settings.name == AppRoutes.createReport) {
          final args = settings.arguments;
          String? reportedProfileId;
          String? dealId;

          if (args is String) {
            reportedProfileId = args;
          } else if (args is Map<String, dynamic>) {
            reportedProfileId = args['reportedProfileId'] as String?;
            dealId = args['dealId'] as String?;
          }

          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => ReportPage(
              reportedProfileId: reportedProfileId,
              dealId: dealId,
            ),
          );
        }

        final page = _pageFor(settings.name);
        if (page != null) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => page,
          );
        }

        return null;
      },
    );
  }

  bool _hasAuthenticatedSession() {
    if (_isAuthenticated != null) {
      return _isAuthenticated();
    }

    try {
      return Supabase.instance.client.auth.currentSession != null;
    } on Object {
      return false;
    }
  }

  static bool _isPublicRoute(String? routeName) {
    return routeName == AppRoutes.welcome ||
        routeName == AppRoutes.signIn ||
        routeName == AppRoutes.signUp ||
        routeName == AppRoutes.forgotPassword;
  }

  static Widget? _pageFor(String? routeName) {
    return switch (routeName) {
      AppRoutes.welcome => const WelcomePage(),
      AppRoutes.deals => const HomePage(),
      AppRoutes.legalNotices => const LegalNoticesPage(),
      AppRoutes.notifications => const NotificationsPage(),
      AppRoutes.createReport => const ReportPage(),
      AppRoutes.profile => const ProfilePage(),
      AppRoutes.myDeals => const MyDealsPage(),
      AppRoutes.signIn => const SignInPage(),
      AppRoutes.signUp => const SignUpPage(),
      AppRoutes.forgotPassword => const ForgotPasswordPage(),
      AppRoutes.studentVerification => const AccountVerificationPage(),
      AppRoutes.dealHistory => const HistoryPage(),
      _ => null,
    };
  }
}
