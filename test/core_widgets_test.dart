import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/core/widgets/app_header.dart';
import 'package:shareplace/core/widgets/app_navigation_drawer.dart';
import 'package:shareplace/core/widgets/share_button.dart';

void main() {
  testWidgets('share button forwards share parameters', (tester) async {
    String? sharedText;
    String? sharedSubject;
    String? sharedTitle;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ShareButton(
            text: 'Annonce SharePlace',
            subject: 'Sujet annonce',
            title: 'Canape vintage',
            onShare: ({required text, subject, title}) async {
              sharedText = text;
              sharedSubject = subject;
              sharedTitle = title;
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    expect(find.byTooltip('Partager'), findsOneWidget);

    await tester.tap(find.byType(ShareButton));
    await tester.pump();

    expect(sharedText, 'Annonce SharePlace');
    expect(sharedSubject, 'Sujet annonce');
    expect(sharedTitle, 'Canape vintage');
  });

  testWidgets('app header shows a menu button when a drawer is available', (
    tester,
  ) async {
    var openedMenu = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppHeader(
            title: 'Profil',
            onMenuPressed: () => openedMenu = true,
          ),
        ),
      ),
    );

    expect(find.text('Profil'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.home), findsNothing);

    await tester.tap(find.byTooltip('Menu'));
    await tester.pump();

    expect(openedMenu, isTrue);
  });

  testWidgets('app header can render a title without navigation button', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppHeader(title: 'Se connecter'),
        ),
      ),
    );

    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsNothing);
    expect(find.byIcon(Icons.home), findsNothing);
  });

  testWidgets('navigation drawer header follows the current route metadata', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          drawer: const AppNavigationDrawer(currentRoute: AppRoutes.profile),
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                child: const Text('Open'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('app-drawer-header')), findsOneWidget);
    expect(find.byKey(const Key('app-drawer-header-icon')), findsOneWidget);
    expect(find.text('Profil'), findsWidgets);

    final headerIcon = tester.widget<Icon>(
      find.byKey(const Key('app-drawer-header-icon')),
    );
    expect(headerIcon.icon, Icons.person_outline);
  });
}
