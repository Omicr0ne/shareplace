# Contribution Workflow

Ce document décrit le workflow Git recommandé pour garder un historique linéaire, protéger `main`, et éviter d'intégrer du code qui ne passe pas la CI.

## Branches

- `main` contient uniquement du code stable et validé.
- `development` sert de branche d'intégration avant `main`.
- les branches de travail partent de `development`.
- les changements passent toujours par Pull Request.
- les merges doivent rester linéaires : pas de merge commit.

## Règles GitHub à activer

Dans `Settings` > `Branches`, créer une règle pour `main`, puis idéalement une autre pour `development`.

Activer :

- `Require a pull request before merging`
- `Require approvals` avec au moins `1` approval
- `Require status checks to pass before merging`
- sélectionner le check `Quality checks`
- `Require branches to be up to date before merging`
- `Require linear history`
- `Do not allow bypassing the above settings`
- `Block force pushes`
- `Block deletions`

Dans `Settings` > `General` > `Pull Requests`, désactiver `Allow merge commits`.

Garder uniquement :

- `Allow squash merging`, recommandé pour les branches feature
- `Allow rebase merging`, utile pour intégrer `development` dans `main` sans merge commit

## Créer une nouvelle branche

Toujours commencer par synchroniser les branches locales.

```bash
git fetch --prune origin
git checkout development
git pull --ff-only origin development
git checkout main
git pull --ff-only origin main
```

Créer ensuite une branche depuis `development`.

```bash
git checkout development
git checkout -b feature/nom-court-de-la-feature
```

Exemples de noms :

- `feature/auth-login`
- `feature/profile-screen`
- `fix/user-form-validation`
- `chore/update-quality-tools`

## Travailler sur la branche

Faire des commits petits et cohérents.

Avant chaque commit, lancer au minimum :

```bash
dart run tool/check.dart --quick
```

Puis committer :

```bash
git status
git add <fichiers>
git commit -m "type: description courte"
```

Exemples de messages :

- `feat: add login form`
- `fix: validate empty profile fields`
- `test: add user profile tests`
- `chore: update flutter quality checks`

Avant d'ouvrir la Pull Request, lancer la vérification complète :

```bash
dart run tool/check.dart
```

Pousser la branche :

```bash
git push -u origin feature/nom-court-de-la-feature
```

## Garder la branche à Jour

Pour conserver un historique linéaire, ne pas faire de merge depuis `development` dans une branche feature.

À éviter :

```bash
git merge development
```

À faire à la place :

```bash
git fetch origin
git rebase origin/development
```

Si Git signale des conflits :

```bash
git status
```

Corriger les fichiers en conflit, puis :

```bash
git add <fichiers-corriges>
git rebase --continue
```

Après un rebase, pousser avec :

```bash
git push --force-with-lease
```

Utiliser uniquement `--force-with-lease`, jamais `--force`. Cette commande refuse d'écraser des changements distants que quelqu'un aurait poussés entre-temps.

## Ouvrir une Pull Request vers `development`

Créer une Pull Request :

```txt
feature/nom-court-de-la-feature -> development
```

Avant de demander une review, vérifier que :

- `dart run tool/check.dart` passe en local
- la CI GitHub `Quality checks` passe
- la Pull Request décrit clairement ce qui change
- les fichiers générés `*.freezed.dart` et `*.g.dart` sont commités quand nécessaire
- aucun fichier secret `.env` n'est commit

Avec GitHub CLI, une PR peut être créée avec :

```bash
gh pr create --base development --head feature/nom-court-de-la-feature --title "feat: description" --body "Résumé des changements"
```

## Intégrer la Pull Request dans `development`

Quand la PR est approuvée et que la CI est verte, utiliser `Squash and merge`.

Cela garde `development` lisible : une feature correspond à un commit final.

Après merge, supprimer la branche distante depuis GitHub ou avec :

```bash
git push origin --delete feature/nom-court-de-la-feature
```

Nettoyer localement :

```bash
git checkout development
git pull --ff-only origin development
git branch -d feature/nom-court-de-la-feature
```

Si la branche locale a été réécrite par squash et que Git refuse `-d`, vérifier d'abord que la PR est bien mergée, puis utiliser :

```bash
git branch -D feature/nom-court-de-la-feature
```

## Préparer le retour vers `main`

Quand `development` est prête à être livrée, synchroniser localement :

```bash
git fetch --prune origin
git checkout development
git pull --ff-only origin development
git checkout main
git pull --ff-only origin main
```

Créer une Pull Request :

```txt
development -> main
```

Avec GitHub CLI :

```bash
gh pr create --base main --head development --title "release: merge development into main" --body "Intègre les changements validés de development vers main."
```

La PR doit passer :

- review obligatoire
- CI `Quality checks`
- branche à jour avec `main`

## Merger `development` dans `main`

Pour garder un historique linéaire sur `main`, ne pas utiliser `Create a merge commit`.

Utiliser l'une de ces options :

- `Rebase and merge` si vous voulez conserver les commits de `development` séparés
- `Squash and merge` si vous voulez un seul commit de release sur `main`

Pour un projet universitaire simple, `Squash and merge` est souvent le plus lisible.

Après le merge vers `main`, synchroniser les branches locales :

```bash
git fetch --prune origin
git checkout main
git pull --ff-only origin main
git checkout development
git pull --ff-only origin development
```

Si `main` a avancé et que `development` doit récupérer ce commit de release, ouvrir une PR courte :

```txt
main -> development
```

ou, si l'équipe maîtrise Git et qu'il n'y a pas de divergence complexe :

```bash
git checkout development
git rebase origin/main
git push --force-with-lease origin development
```

Ne faire cette dernière option que si toute l'équipe est d'accord, car elle réécrit l'historique de `development`.

## Commandes de diagnostic utiles

Voir la branche actuelle et son état :

```bash
git status --short --branch
```

Voir les branches locales et leur branche distante :

```bash
git branch -vv
```

Comparer `main` locale avec `origin/main` :

```bash
git rev-list --left-right --count main...origin/main
```

Comparer `development` locale avec `origin/development` :

```bash
git rev-list --left-right --count development...origin/development
```

Résultat attendu si tout est synchronisé :

```txt
0 0
```

Voir l'historique sous forme lisible :

```bash
git log --oneline --graph --decorate --all
```

Voir les derniers runs CI :

```bash
gh run list --workflow "Flutter CI" --limit 5
```

Voir une Pull Request :

```bash
gh pr view <numero>
```

## Résumé court

Workflow feature :

```bash
git fetch --prune origin
git checkout development
git pull --ff-only origin development
git checkout -b feature/ma-feature
dart run tool/check.dart
git add <fichiers>
git commit -m "feat: ma feature"
git push -u origin feature/ma-feature
gh pr create --base development --head feature/ma-feature
```

Si la branche doit être mise à jour :

```bash
git fetch origin
git rebase origin/development
git push --force-with-lease
```

Workflow release :

```bash
git fetch --prune origin
git checkout development
git pull --ff-only origin development
git checkout main
git pull --ff-only origin main
gh pr create --base main --head development --title "release: merge development into main"
```
