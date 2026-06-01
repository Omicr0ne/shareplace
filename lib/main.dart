import 'package:flutter/material.dart';
import 'package:shareplace/core/pages/inscription2.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InscriptionScreenK(),
    );
  }
}
