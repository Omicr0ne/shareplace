import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
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
                  onPressed: () {},
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
                  onPressed: () {},
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
