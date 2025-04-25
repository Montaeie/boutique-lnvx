#!/bin/bash

# Définir les couleurs pour une meilleure lisibilité
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Variables pour suivre les PID
BACKEND_PID=""
FRONTEND_PID=""

# Fonction d'aide
show_help() {
  echo -e "Script de gestion pour le projet Boutique LNVX"
  echo ""
  echo "Usage: ./boutique-lnvx.sh [OPTION]"
  echo ""
  echo "Options:"
  echo "  start       Démarre tous les services"
  echo "  stop        Arrête tous les services"
  echo "  restart     Redémarre tous les services"
  echo "  backend     Démarre uniquement le backend"
  echo "  frontend    Démarre uniquement le frontend"
  echo "  database    Démarre uniquement les services PostgreSQL et Redis"
  echo "  docker      Démarre la version dockerisée complète"
  echo "  docker-dev  Démarre la version dockerisée pour le développement"
  echo "  status      Vérifie l'état des services"
  echo "  logs        Affiche les logs des services Docker"
  echo "  setup       Configure l'environnement (dev, test, staging, prod)"
  echo "  test        Exécute les tests"
  echo "  help        Affiche cette aide"
}

# Fonction pour vérifier l'état d'un service
check_service() {
  local port=$1
  local name=$2
  
  if nc -z localhost $port >/dev/null 2>&1; then
    echo -e "✓ $name est en cours d'exécution (port $port)"
    return 0
  else
    echo -e "✗ $name n'est pas en cours d'exécution (port $port)"
    return 1
  fi
}

# Fonction pour attendre qu'un service soit prêt
wait_for_service() {
  local port=$1
  local name=$2
  local max_attempts=$3
  local attempt=1
  
  echo -e "   Attente du démarrage de $name..."
  
  while ! nc -z localhost $port >/dev/null 2>&1; do
    sleep 1
    attempt=$((attempt+1))
    if [ $attempt -gt $max_attempts ]; then
      echo -e "Timeout en attendant $name"
      return 1
    fi
  done
  
  echo -e "✓ $name est prêt"
  return 0
}

# Fonction pour démarrer les services de base (PostgreSQL et Redis)
start_database() {
  echo -e "Démarrage de PostgreSQL et Redis..."
  
  # Vérifier si Docker est en cours d'exécution
  if ! docker info >/dev/null 2>&1; then
    echo -e "Docker n'est pas en cours d'exécution. Veuillez démarrer Docker d'abord."
    exit 1
  fi
  
  docker-compose up -d postgres redis
  
  # Vérifier que PostgreSQL et Redis sont bien démarrés
  wait_for_service 5432 "PostgreSQL" 30 || return 1
  wait_for_service 6379 "Redis" 10 || return 1
  
  echo -e "✓ Services de base démarrés"
  return 0
}

# Fonction pour démarrer le backend
start_backend() {
  if [ -n "$BACKEND_PID" ]; then
    echo -e "Le backend est déjà en cours d'exécution (PID: $BACKEND_PID)"
    return 0
  fi
  
  echo -e "Démarrage du backend Medusa..."
  cd boutique-lnvx
  npm run dev &
  BACKEND_PID=$!
  cd ..
  
  # Vérifier que le backend est bien démarré
  wait_for_service 9000 "Backend Medusa" 30 || return 1
  
  echo -e "✓ Backend démarré sur http://localhost:9000"
  return 0
}

# Fonction pour démarrer le frontend
start_frontend() {
  if [ -n "$FRONTEND_PID" ]; then
    echo -e "Le frontend est déjà en cours d'exécution (PID: $FRONTEND_PID)"
    return 0
  fi
  
  echo -e "Démarrage du storefront Next.js..."
  cd boutique-lnvx-storefront
  npm run dev &
  FRONTEND_PID=$!
  cd ..
  
  # Vérifier que le frontend est bien démarré
  wait_for_service 8000 "Frontend Next.js" 30 || return 1
  
  echo -e "✓ Storefront démarré sur http://localhost:8000"
  return 0
}

# Fonction pour arrêter les services
stop_services() {
  echo -e "Arrêt des services..."
  
  # Arrêter le frontend
  if [ -n "$FRONTEND_PID" ]; then
    echo "Arrêt du frontend (PID: $FRONTEND_PID)..."
    kill $FRONTEND_PID 2>/dev/null
    FRONTEND_PID=""
  fi
  
  # Arrêter le backend
  if [ -n "$BACKEND_PID" ]; then
    echo "Arrêt du backend (PID: $BACKEND_PID)..."
    kill $BACKEND_PID 2>/dev/null
    BACKEND_PID=""
  fi
  
  # Arrêter les services Docker
  echo "Arrêt des services Docker..."
  docker-compose down
  
  echo -e "Services arrêtés."
}

# Fonction pour vérifier l'état de tous les services
check_status() {
  echo -e "Vérification de l'état des services:"
  
  echo "1. Services de base:"
  check_service 5432 "PostgreSQL"
  check_service 6379 "Redis"
  
  echo "2. Application:"
  check_service 9000 "Backend Medusa"
  check_service 8000 "Frontend Next.js"
  
  # Vérifier les conteneurs Docker
  echo ""
  echo "3. Conteneurs Docker:"
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# Fonction pour démarrer tous les services
start_all() {
  start_database || return 1
  start_backend || return 1
  start_frontend || return 1
  
  echo ""
  echo -e "✅ Environnement Boutique LNVX prêt!"
  echo -e "- Storefront: http://localhost:8000"
  echo -e "- Backend API: http://localhost:9000"
  echo -e "- Admin Medusa: http://localhost:9000/app"
  echo ""
  echo "Appuyez sur Ctrl+C pour tout arrêter"
}

# Fonction pour démarrer la version dockerisée
start_docker() {
  echo -e "Démarrage de l'environnement dockerisé..."
  docker-compose up
}

# Fonction pour démarrer la version dockerisée de développement
start_docker_dev() {
  echo -e "Démarrage de l'environnement dockerisé pour le développement..."
  docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
}

# Fonction pour configurer l'environnement
setup_env() {
  local env=${1:-development}
  
  echo -e "Configuration de l'environnement $env..."
  ./scripts/setup-env.sh $env
  
  echo -e "Configuration terminée."
}

# Fonction pour exécuter les tests
run_tests() {
  echo -e "Exécution des tests..."
  
  # Configurer l'environnement de test
  setup_env test
  
  # Exécuter les tests du backend
  cd boutique-lnvx
  npm test
  local backend_result=$?
  cd ..
  
  # Exécuter les tests du frontend
  cd boutique-lnvx-storefront
  npm test
  local frontend_result=$?
  cd ..
  
  # Vérifier les résultats
  if [ $backend_result -eq 0 ] && [ $frontend_result -eq 0 ]; then
    echo -e "Tous les tests ont réussi."
    return 0
  else
    echo -e "Certains tests ont échoué."
    return 1
  fi
}

# Fonction principale
main() {
  case "$1" in
    start)
      start_all
      ;;
    stop)
      stop_services
      ;;
    restart)
      stop_services
      start_all
      ;;
    backend)
      start_database && start_backend
      ;;
    frontend)
      start_database && start_backend && start_frontend
      ;;
    database)
      start_database
      ;;
    status)
      check_status
      ;;
    logs)
      docker-compose logs -f
      ;;
    docker)
      start_docker
      ;;
    docker-dev)
      start_docker_dev
      ;;
    setup)
      setup_env $2
      ;;
    test)
      run_tests
      ;;
    help|*)
      show_help
      ;;
  esac
}

# Intercepter Ctrl+C
trap stop_services SIGINT SIGTERM

# Exécuter la fonction principale avec les arguments
main "$@"

# Si aucun argument n'est fourni, afficher l'aide
if [ $# -eq 0 ]; then
  show_help
fi

# Si on démarre tout, attendre indéfiniment (jusqu'à Ctrl+C)
if [ "$1" = "start" ]; then
  # Afficher périodiquement un message pour éviter l'impression que le script est bloqué
  while true; do
    sleep 300
    echo -e "$(date) - Environnement Boutique LNVX en cours d'exécution..."
  done
fi
