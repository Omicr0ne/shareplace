import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareplace/main.dart';

void main() {
  testWidgets('shows the initial home page', (tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Inscription'), findsOneWidget);
    expect(find.text('Nom'), findsOneWidget);
    expect(find.text('Prénom'), findsOneWidget);
    expect(find.text('Numéro de téléphone'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Confirmer le mot de passe'), findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);
    expect(find.text('Je possède déjà un compte'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('navigates to step 2 when step 1 form is valid', (tester) async {
    await tester.pumpWidget(const MainApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'Dupont');
    await tester.enterText(find.byType(TextFormField).at(1), 'Alice');
    await tester.enterText(find.byType(TextFormField).at(2), '+33612345678');
    await tester.enterText(find.byType(TextFormField).at(3), 'alice@test.com');
    await tester.enterText(find.byType(TextFormField).at(4), 'secret123');
    await tester.enterText(find.byType(TextFormField).at(5), 'secret123');

    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Importer une photo de profil'), findsOneWidget);
  });
}
