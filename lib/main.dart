import 'package:flutter/material.dart';
import 'package:shareplace/pages/signalement_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shareplace',
      debugShowCheckedModeBanner: false, // Optionnel : retire le bandeau debug
      // On affiche directement la page de signalement en page d'accueil
      home: SignalementPage(),
    );
  }
}
