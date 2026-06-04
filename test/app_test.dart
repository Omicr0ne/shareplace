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

  testWidgets('opens my deals page from initial web route', (tester) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue =
        AppRoutes.myDeals;
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );

    await tester.pumpWidget(const SharePlaceApp());

    expect(find.text('Mes offres'), findsOneWidget);
    expect(find.text('Profil'), findsNothing);
  });
}
