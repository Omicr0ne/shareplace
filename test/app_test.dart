import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/app/shareplace_app.dart';

void main() {
  test('defines app route paths', () {
    expect(AppRoutes.welcome, '/welcome');
    expect(AppRoutes.deals, '/deals');
    expect(AppRoutes.createDeal, '/deals/create');
    expect(AppRoutes.dealDetails('abc-123'), '/deals/abc-123');
    expect(AppRoutes.myDeals, '/deals/mine');
    expect(AppRoutes.dealHistory, '/deals/history');
    expect(AppRoutes.profile, '/profile');
    expect(AppRoutes.studentVerification, '/profile/student-verification');
    expect(AppRoutes.signIn, '/sign-in');
    expect(AppRoutes.signUp, '/sign-up');
    expect(AppRoutes.forgotPassword, '/forgot-password');
    expect(AppRoutes.createReport, '/reports/create');
  });

  testWidgets('opens my deals page from initial web route when signed in', (
    tester,
  ) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue =
        AppRoutes.myDeals;
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );

    await tester.pumpWidget(SharePlaceApp(isAuthenticated: () => true));

    expect(find.text('Mes offres'), findsOneWidget);
    expect(find.text('Profil'), findsNothing);
  });

  testWidgets('redirects protected web routes to sign in by default', (
    tester,
  ) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue =
        AppRoutes.myDeals;
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );

    await tester.pumpWidget(SharePlaceApp(isAuthenticated: () => false));

    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Mes offres'), findsNothing);
  });
}
