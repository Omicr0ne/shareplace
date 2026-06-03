import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/app/shareplace_app.dart';

void main() {
  test('defines app route paths', () {
    expect(AppRoutes.welcome, '/welcome');
    expect(AppRoutes.home, '/home');
    expect(AppRoutes.profile, '/profile');
    expect(AppRoutes.login, '/login');
    expect(AppRoutes.register, '/register');
    expect(AppRoutes.profileVerification, '/profile-verification');
    expect(AppRoutes.myDeals, '/my-deals');
    expect(AppRoutes.addProduct, '/add-product');
    expect(AppRoutes.forgotPassword, '/forgot-password');
    expect(AppRoutes.search, '/search-filter');
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
