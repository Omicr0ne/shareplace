import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/main.dart';

void main() {
  testWidgets('shows the initial home page', (tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Historique'), findsOneWidget);
    expect(find.text('Petite armoire'), findsWidgets);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
