import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/main.dart';

void main() {
  testWidgets('shows the initial home page', (tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Nouvelle demande de deal'), findsWidgets);
    expect(find.text('Deal accepté'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
