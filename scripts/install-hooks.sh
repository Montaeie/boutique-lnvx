#!/bin/bash

echo "Installation des hooks Git..."

# Copier tous les hooks du dossier .git/hooks vers les projets enfants
mkdir -p boutique-lnvx/.git/hooks
mkdir -p boutique-lnvx-storefront/.git/hooks

cp .git/hooks/pre-commit boutique-lnvx/.git/hooks/
cp .git/hooks/pre-commit boutique-lnvx-storefront/.git/hooks/

chmod +x boutique-lnvx/.git/hooks/pre-commit
chmod +x boutique-lnvx-storefront/.git/hooks/pre-commit

echo "Hooks Git installés avec succès!"
