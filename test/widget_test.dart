import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/main.dart';

void main() {
  testWidgets('shows the initial home page', (tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Inscription'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Importer une photo de profil'), findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
