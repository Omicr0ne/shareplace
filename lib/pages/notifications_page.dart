import 'package:flutter/material.dart';

// Classe de modèle locale simulant la jointure Supabase
// (Deals + Profiles + Applications).
class ShareplaceNotification {
  const ShareplaceNotification({
    required this.id,
    required this.title,
    required this.dealTitle,
    required this.senderFirstName,
    required this.imageUrl,
    required this.isUnread,
    required this.createdAt,
  });

  final String id;
  final String title; // "Nouvelle demande de deal" ou "Deal accepté"
  final String dealTitle; // ex: "Petite armoire"
  final String senderFirstName; // Jointure profiles.first_name (ex: "JeanMi")
  final String imageUrl; // Jointure deal_images.url
  final bool isUnread; // État de lecture de la notification
  final DateTime createdAt;
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Mock de données structurées selon votre schéma Supabase pour le Sprint 1
  final List<ShareplaceNotification> _notifications = [
    ShareplaceNotification(
      id: '1',
      title: 'Nouvelle demande de deal',
      dealTitle: 'Petite armoire',
      senderFirstName: 'JeanMi',
      imageUrl:
          'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=200', // Image d'armoire meuble
      isUnread: true,
      createdAt: DateTime.now(),
    ),
    ShareplaceNotification(
      id: '2',
      title: 'Deal accepté',
      dealTitle: 'Petite armoire',
      senderFirstName: 'JeanMi',
      imageUrl:
          'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=200',
      isUnread: true,
      createdAt: DateTime.now(),
    ),
    ShareplaceNotification(
      id: '3',
      title: 'Nouvelle demande de deal',
      dealTitle: 'Petite armoire',
      senderFirstName: 'JeanMi',
      imageUrl:
          'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=200',
      isUnread: false,
      createdAt: DateTime.now(),
    ),
    ShareplaceNotification(
      id: '4',
      title: 'Nouvelle demande de deal',
      dealTitle: 'Petite armoire',
      senderFirstName: 'JeanMi',
      imageUrl:
          'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=200',
      isUnread: false,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF1E1E1E,
      ), // Fond sombre d'arrière-plan de la maquette
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              color: Colors.white, // Grande feuille blanche arrondie
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Zone d'en-tête (Flèche retour + Titre Orange)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF841D), // Orange de la DA
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Flux de notifications
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _notifications.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Color(0xFFEEEEEE),
                      thickness: 1,
                      height: 24,
                    ),
                    itemBuilder: (context, index) {
                      final item = _notifications[index];
                      return Row(
                        children: [
                          // Image du produit (Table deal_images)
                          // avec angles arrondis.
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              item.imageUrl,
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 75,
                                  height: 75,
                                  color: Colors.amber.shade700,
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Bloc de textes
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.dealTitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Expéditeur (Table profiles)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.account_circle,
                                      size: 18,
                                      color: Color(0xFFFF841D),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'De ${item.senderFirstName}',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Pastille rouge de notification non lue (Maquette)
                          if (item.isUnread)
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
