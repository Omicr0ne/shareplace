import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    this.onLoginPressed,
    this.onRegisterPressed,
  });

  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo de l'application.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'lib/core/assets/images/logo_sp.png',
                        height: 500,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Nom de l'application.
                    Text(
                      'SharePlace',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Phrase de slogan.
                    Text(
                      'Slogan à définir',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF5D4037),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Boutons d'action.
                    Row(
                      children: [
                        Expanded(child: _primaryButton(context)),
                        const SizedBox(width: 12),
                        Expanded(child: _secondaryButton(context)),
                      ],
                    ),

						// Espace avant le bouton 'Accueil' pour séparation visuelle
						const SizedBox(height: 16),

						// Bouton de test pour accéder à la page d'accueil (à supprimer)
						Row(
							children: [
								Expanded(child: _homeButton(context)),
							],
						),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bouton de connexion.
  Widget _primaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: onLoginPressed ?? () => _showComingSoon(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEF6C00),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text('Se connecter'),
    );
  }

  // Bouton d'inscription.
  Widget _secondaryButton(BuildContext context) {
    return OutlinedButton(
      onPressed: onRegisterPressed ?? () => _showComingSoon(context),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFEF6C00), width: 1.4),
        foregroundColor: const Color(0xFFBF360C),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text("S'inscrire"),
    );
  }

  // Bouton d'accès direct à la page d'accueil (à supprimer)
  Widget _homeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, '/home'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEF6C00),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text('Accueil'),
    );
  }

  // Message de page à venir.
  static void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('En développement.')),
    );
  }
}
