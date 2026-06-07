# SharePlace

## Prérequis

- Flutter SDK installé sur la machine.
- Git installé sur la machine.
- Un éditeur au choix : Android Studio, VS Code, IntelliJ, etc.

Le projet doit pouvoir être lancé depuis macOS, Linux et Windows. Pour cette raison, les commandes qualité sont centralisées dans un script Dart plutôt que dans un script shell ou un Makefile.

## Installation

Après avoir cloné le projet :

```bash
flutter pub get
```

Créer ensuite un fichier `.env` à la racine du projet à partir de `.env.example` :

```env
SUPABASE_URL=https://votre-projet.supabase.co
SUPABASE_ANON_KEY=votre-cle-anon
```

L'application charge ce fichier au démarrage avec `flutter_dotenv` pour initialiser Supabase.

Pour vérifier que l'environnement Flutter est correct :

```bash
flutter doctor
```

## Commandes Qualité

Avant d'ouvrir une Pull Request, lancer :

```bash
dart run tool/check.dart
```

Cette commande exécute :

- `flutter pub get`
- `dart run build_runner build`
- `dart format --set-exit-if-changed lib test tool`
- `flutter analyze`
- `flutter test`
- `dart run dependency_validator`

Pour une vérification plus rapide avant un commit local :

```bash
dart run tool/check.dart --quick
```

Cette variante lance seulement le formatage et l'analyse statique.

## Seeder Supabase

Un script de seed est disponible pour charger un jeu de données de dev dans Supabase, et le retirer ensuite.

Commandes :

```bash
dart run tool/seed/supabase_seed.dart seed
```

```bash
dart run tool/seed/supabase_seed.dart reset
```

`reset` vide les tables `reports`, `deal_applications`, `deal_tags`, `deals` et `profiles`.

Par défaut, le script lit `.env`. Vous pouvez préciser un autre fichier :

```bash
dart run tool/seed/supabase_seed.dart seed --env=.env.local
```

Variables nécessaires dans le fichier d'environnement :

- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY` (recommandé)
- ou `SUPABASE_ANON_KEY` (fallback, peut échouer selon vos policies RLS)

## GitHub CI Obligatoire

La CI GitHub Actions est définie dans `.github/workflows/flutter-ci.yml`.

Elle est lancée automatiquement sur :

- chaque Pull Request vers `main` ou `development`
- chaque push sur `main` ou `development`

La CI lance la même commande que les développeurs :

```bash
dart run tool/check.dart
```

## Workflow d'équipe recommandé

- `main` contient le code stable.
- `development` sert de branche d'integration.
- chaque fonctionnalite est developpee sur une branche dediee, par exemple `feature/login`.
- les changements passent par Pull Request.
- au moins une autre personne relit la Pull Request avant merge.

Le processus Git complet est décrit dans [`CONTRIBUTING.md`](CONTRIBUTING.md).

Avant de demander une review :

```bash
dart run tool/check.dart
```
