import 'package:flutter/material.dart';

class SignalementPage extends StatefulWidget {
  const SignalementPage({super.key});

  @override
  State<SignalementPage> createState() => _SignalementPageState();
}

class _SignalementPageState extends State<SignalementPage> {
  // Contrôleur pour récupérer le texte saisi par l'utilisateur
  final TextEditingController _motifController = TextEditingController();

  @override
  void dispose() {
    _motifController
        .dispose(); // Bonne pratique pour éviter les fuites de mémoire
    super.dispose();
  }

  // Fonction de validation pour le MVP
  void _validerSignalement() {
    final motifSaisi = _motifController.text.trim();

    if (motifSaisi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un motif avant de valider.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Effet visuel pour la simulation d'envoi (Futur Supabase)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signalement envoyé : "$motifSaisi"'),
        backgroundColor: const Color(0xFFFF841D),
      ),
    );

    // Retour à l'écran précédent
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Arrière-plan sombre
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white, // Conteneur blanc de la maquette
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bouton retour
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

                  // Titre "Signaler un profil"
                  const Center(
                    child: Text(
                      'Signaler un profil',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF841D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Avatar
                  Center(
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey.shade400,
                      child: const Icon(
                        Icons.person,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // À propos de
                  const Text(
                    'A propos de JeanMi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'JeanMi, 34 ans, Paris\n'
                    'Retraité de la SNCF à Lyon. Je vends régulièrement des '
                    'objets de collection (vinyles, vieux outils) et cherche '
                    'des pièces détachées pour restaurer ma Peugeot 205. '
                    "J'utilise surtout l'appli sur mon smartphone, avec des "
                    'filtres pour cibler les annonces dans un rayon de 30 km, '
                    'et je préfère les échanges en personne pour éviter les '
                    "frais d'envoi.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // NOUVEAU : Champ texte à la place de la liste déroulante
                  TextField(
                    controller: _motifController,
                    maxLines: null,
                    // Permet au champ de s'agrandir si le texte est long
                    minLines: 1,
                    // Taille initiale d'une ligne comme sur la maquette
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Motif',
                      hintStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: const Color(
                        0xFFF2F4FF,
                      ), // Couleur bleutée/grise claire de l'image
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide.none, // Supprime la bordure par défaut
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Bouton Valider
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF841D).withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _validerSignalement,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF841D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Valider',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
