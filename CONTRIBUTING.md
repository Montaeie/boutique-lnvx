# Guide de contribution

Merci de contribuer au projet Boutique LNVX! Voici quelques directives pour vous aider à contribuer efficacement.

## Processus de développement

Nous suivons un workflow basé sur Git Flow:

1. **Branches principales**:
   - `main`: Représente la version de production
   - `develop`: Représente la version de développement

2. **Branches de fonctionnalités**:
   - Pour chaque nouvelle fonctionnalité, créez une branche à partir de `develop`:
     ```bash
     git checkout develop
     git pull
     git checkout -b feature/nom-de-la-fonctionnalite
     ```

3. **Branches de correctifs**:
   - Pour un correctif urgent en production:
     ```bash
     git checkout main
     git pull
     git checkout -b hotfix/description-du-correctif
     ```

## Conventions de codage

### JavaScript/TypeScript
- Utilisez ESLint pour vérifier votre code
- Respectez les règles de formatage définies dans .eslintrc
- Utilisez des noms de variables et fonctions explicites

### CSS/SCSS
- Utilisez des classes BEM (Block Element Modifier)
- Évitez les styles trop spécifiques
- Privilégiez les variables pour les couleurs et tailles

### Tests
- Écrivez des tests pour chaque nouvelle fonctionnalité
- Assurez-vous que tous les tests passent avant de soumettre un PR
- Visez une couverture de test d'au moins 70%

## Processus de Pull Request

1. Assurez-vous que votre code est bien testé
2. Mettez à jour la documentation si nécessaire
3. Créez une Pull Request (PR) vers la branche appropriée
4. Décrivez clairement les changements dans la description de la PR
5. Attendez la revue de code et l'approbation
6. Corrigez les commentaires si nécessaire

## Intégration continue

Nous utilisons GitHub Actions pour:
- Exécuter les tests automatiquement
- Vérifier le linting du code
- Construire et déployer l'application

Votre PR ne sera pas fusionnée si ces vérifications échouent.

## Sécurité

Si vous découvrez une faille de sécurité, veuillez nous contacter directement à security@votre-domaine.com au lieu de créer une issue publique.

Merci de contribuer à rendre Boutique LNVX meilleur !
