import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/auth/data/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    AuthService? authService,
    super.key,
  }) : _authService = authService;

  final AuthService? _authService;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthService _authService = widget._authService ?? AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      await _authService.signInWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) {
        return;
      }
      unawaited(
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.home,
          (_) => false,
        ),
      );
    } on Object catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion impossible : $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.blue.shade900; // couleur au clic
                      }
                      return Colors.blue; // couleur normale
                    }),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () => unawaited(_login()),
                  child: const Text('Connexion'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.blue.shade900; // couleur au clic
                      }
                      return Colors.blue; // couleur normale
                    }),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.forgotPassword,
                  ),
                  child: const Text('Mot de passe oublié'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.blue.shade900; // couleur au clic
                      }
                      return Colors.blue; // couleur normale
                    }),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.registration,
                  ),
                  child: const Text('Créer un compte'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
