import 'package:flutter/material.dart';
import 'package:shareplace/pages/historique_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shareplace',
      debugShowCheckedModeBanner: false,
      home: HistoriquePage(),
    );
  }
}
