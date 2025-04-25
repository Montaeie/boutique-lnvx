#!/bin/bash

# Couleurs pour une meilleure lisibilité
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "Configuration du projet Boutique LNVX..."

# Vérifier les prérequis
echo -e "Vérification des prérequis..."

# Vérifier Node.js
if ! command -v node &> /dev/null; then
    echo -e "Node.js n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier npm
if ! command -v npm &> /dev/null; then
    echo -e "npm n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier git
if ! command -v git &> /dev/null; then
    echo -e "git n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier Docker
if ! command -v docker &> /dev/null; then
    echo -e "Docker n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo -e "Docker Compose n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

echo -e "✓ Tous les prérequis sont installés"

# Générer des secrets sécurisés
echo -e "Génération des secrets..."
./scripts/generate-secrets.sh

# Configurer l'environnement de développement
echo -e "Configuration de l'environnement de développement..."
./scripts/setup-env.sh development

# Installer les dépendances du backend
echo -e "Installation des dépendances du backend..."
cd boutique-lnvx
npm install
cd ..

# Installer les dépendances du frontend
echo -e "Installation des dépendances du frontend..."
cd boutique-lnvx-storefront
npm install
cd ..

# Installer les hooks Git
echo -e "Installation des hooks Git..."
./scripts/install-hooks.sh

echo -e "✅ Configuration terminée!"
echo ""
echo -e "Pour démarrer l'environnement de développement, exécutez:"
echo -e "./boutique-lnvx.sh start"
echo ""
echo -e "Pour plus d'options, exécutez:"
echo -e "./boutique-lnvx.sh help"
