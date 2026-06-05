import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/core/widgets/app_page_scaffold.dart';

class LegalNoticesPage extends StatelessWidget {
  const LegalNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageScaffold(
      title: 'Mentions légales',
      currentRoute: AppRoutes.legalNotices,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SHAREPLACE',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Application de marketplace étudiante gratuite dédiée au don et '
              "à l'anti-gaspillage.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Divider(height: 30),

            Text(
              '1. Équipe du projet (SAE DEV MOBILE)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• CANEVY Mendhy (Scrum Master)'),
            Text('• MILIA Ethane (Product Owner)'),
            Text('• MEUNIER Matthieu (Développeur)'),
            Text('• PERSAND Sean (Développeur)'),
            Text('• BOISFER Alexandre (Développeur)'),
            SizedBox(height: 20),

            Text(
              '2. Hébergement & Données',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Les données de l'authentification et des donations des "
              'utilisateurs sont stockées sur la base de données distribuée '
              'Supabase.',
            ),
            SizedBox(height: 20),

            Text(
              '3. Avertissement Produits Alimentaires',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pour les produits alimentaires, le donneur doit '
              'obligatoirement entrer la date de péremption ainsi '
              "qu'une photo de celle-ci. C'est à l'utilisateur final "
              'de vérifier la validité du produit lors de la remise '
              "en main propre. L'application décline toute "
              'responsabilité.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Text(
              '4. Fonctionnalités et Autorisations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "L'application utilise la géolocalisation pour détecter "
              "l'adresse et calculer les distances, ainsi que l'appareil "
              "photo pour l'ajout des images des dons. Elle intègre "
              'également un système de notation des profils et un compte '
              'à rebours de 3 heures pour les ventes flash non '
              'alimentaires.',
            ),
            SizedBox(height: 20),

            Text(
              '5. Propriété Intellectuelle',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Le concept, le code source et les visuels de Shareplace sont '
              'la propriété exclusive des membres du groupe de la SAE.',
            ),
            SizedBox(height: 40),

            Center(
              child: Text(
                'Version 1.0.0 (Sprint 1) - Usage Académique',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
