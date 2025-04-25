#!/bin/bash

# Ce script génère des secrets sécurisés pour l'application

# Vérifier si openssl est installé
if ! command -v openssl &> /dev/null; then
    echo "openssl n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Générer un secret JWT
JWT_SECRET=$(openssl rand -base64 32)

# Générer un secret pour les cookies
COOKIE_SECRET=$(openssl rand -base64 32)

# Créer ou mettre à jour le fichier .env avec les nouveaux secrets
if [ -f ".env" ]; then
    # Si le fichier existe, mettre à jour les variables
    sed -i.bak "s/^JWT_SECRET=.*/JWT_SECRET=$JWT_SECRET/" .env
    sed -i.bak "s/^COOKIE_SECRET=.*/COOKIE_SECRET=$COOKIE_SECRET/" .env
    rm .env.bak  # Supprimer le fichier de sauvegarde
else
    # Sinon, créer un nouveau fichier .env
    cat > .env << EOF
JWT_SECRET=$JWT_SECRET
COOKIE_SECRET=$COOKIE_SECRET
EOF
fi

echo "Secrets générés avec succès et enregistrés dans .env"
echo "JWT_SECRET=$JWT_SECRET"
echo "COOKIE_SECRET=$COOKIE_SECRET"
