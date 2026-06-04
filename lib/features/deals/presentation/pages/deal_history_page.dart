import 'package:flutter/material.dart';

// Modèle de données calqué sur le schéma Supabase pour structurer l'historique
class HistoryDeal {
  const HistoryDeal({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.formattedDate,
    required this.state,
  });

  final String id;
  final String title; // deals.title (ex: "Petite armoire")
  final String description; // deals.description
  final String imageUrl; // deal_images.url
  final String formattedDate; // deal.updated_at formaté pour l'affichage
  final String state; // deal_state (ici toujours 'closed' ou conclu)
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  // Simulation des données d'historique (Deals conclus/closed) pour le Sprint 1
  static const List<HistoryDeal> _historiqueDeals = [
    HistoryDeal(
      id: '1',
      title: 'Petite armoire',
      description:
          'Petite armoire à donner...\n'
          "Un peu usée par le temps, mais pleine d'histoires à raconter. "
          'Elle a connu des matins pressés, des vêtements...',
      imageUrl:
          'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=300',
      formattedDate: '12/05/2026',
      state: 'closed',
    ),
    HistoryDeal(
      id: '2',
      title: 'Petite armoire',
      description:
          'Petite armoire à donner...\n'
          "Un peu usée par le temps, mais pleine d'histoires à raconter. "
          'Elle a connu des matins pressés, des vêtements...',
      imageUrl:
          'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=300',
      formattedDate: '28/04/2026',
      state: 'closed',
    ),
    HistoryDeal(
      id: '3',
      title: 'Petite armoire',
      description:
          'Petite armoire à donner...\n'
          "Un peu usée par le temps, mais pleine d'histoires à raconter. "
          'Elle a connu des matins pressés, des vêtements...',
      imageUrl:
          'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=300',
      formattedDate: '15/04/2026',
      state: 'closed',
    ),
    HistoryDeal(
      id: '4',
      title: 'Petite armoire',
      description:
          'Petite armoire à donner...\n'
          "Un peu usée par le temps, mais pleine d'histoires à raconter. "
          'Elle a connu des matins pressés, des vêtements...',
      imageUrl:
          'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=300',
      formattedDate: '02/04/2026',
      state: 'closed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Historique',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF841D), // Orange caractéristique de Shareplace
          ),
        ),
        // Flèche de retour si la page est poussée dans la navigation
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _historiqueDeals.length,
        itemBuilder: (context, index) {
          final deal = _historiqueDeals[index];
          return _buildHistoryCard(deal);
        },
      ),
    );
  }

  // Construction de la carte d'historique avec sa bordure orange
  Widget _buildHistoryCard(HistoryDeal deal) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFF841D), // Couleur orange de la bordure
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre du Deal centré en haut de la carte
          Center(
            child: Text(
              deal.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Ligne contenant l'image et la description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image du deal avec des angles arrondis
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  deal.imageUrl,
                  width: 120,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 100,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, color: Colors.white),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),

              // Description du deal
              Expanded(
                child: Text(
                  deal.description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Zone inférieure : Case verte de validation et date du deal
          Padding(
            padding: const EdgeInsets.only(
              left: 100,
            ), // Aligné sous le début de la description
            child: Row(
              children: [
                const Icon(
                  Icons.check_box,
                  color: Color(0xFF00B25C), // Vert de validation de la maquette
                  size: 24,
                ),
                const SizedBox(width: 6),
                Text(
                  '(${deal.formattedDate})',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
