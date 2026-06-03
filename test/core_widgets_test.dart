import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
