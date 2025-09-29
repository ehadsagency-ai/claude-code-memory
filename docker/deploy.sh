#!/bin/bash

# Claude Code CEO - One-Click Docker Deployment
# Script de déploiement automatique via URL

set -e

echo "🐳 CLAUDE CODE CEO - ONE-CLICK DEPLOYMENT"
echo "========================================"
echo ""

# Configuration
DOCKER_IMAGE="ehadsagency-ai/claude-code-ceo"
CONTAINER_NAME="claude-code-ceo"
GITHUB_REPO="https://github.com/ehadsagency-ai/claude-code-memory.git"
DEPLOY_DIR="$HOME/.claude-docker-deploy"
VERSION="latest"

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction de logging
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

success() {
    log "${GREEN}✅ $1${NC}"
}

warning() {
    log "${YELLOW}⚠️  $1${NC}"
}

error() {
    log "${RED}❌ $1${NC}"
}

info() {
    log "${BLUE}ℹ️  $1${NC}"
}

# Vérification des prérequis
check_prerequisites() {
    info "Vérification des prérequis..."

    # Vérifier Docker
    if ! command -v docker &> /dev/null; then
        error "Docker n'est pas installé"
        echo "💡 Installer Docker: https://docs.docker.com/get-docker/"
        exit 1
    fi

    # Vérifier Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null 2>&1; then
        error "Docker Compose n'est pas installé"
        echo "💡 Installer Docker Compose: https://docs.docker.com/compose/install/"
        exit 1
    fi

    # Vérifier que Docker fonctionne
    if ! docker ps &> /dev/null; then
        error "Docker n'est pas démarré"
        echo "💡 Démarrer Docker et réessayer"
        exit 1
    fi

    success "Prérequis vérifiés"
}

# Nettoyage des déploiements précédents
cleanup_previous() {
    info "Nettoyage des déploiements précédents..."

    # Arrêter le conteneur s'il existe
    if docker ps -aq -f name="$CONTAINER_NAME" | grep -q .; then
        docker stop "$CONTAINER_NAME" 2>/dev/null || true
        docker rm "$CONTAINER_NAME" 2>/dev/null || true
        success "Conteneur précédent supprimé"
    fi

    # Nettoyer les images orphelines
    docker image prune -f > /dev/null 2>&1 || true
}

# Téléchargement des configurations
download_config() {
    info "Téléchargement de la configuration depuis GitHub..."

    # Créer le répertoire de déploiement
    mkdir -p "$DEPLOY_DIR"
    cd "$DEPLOY_DIR"

    # Cloner ou mettre à jour le repository
    if [ -d ".git" ]; then
        git pull origin main || git pull origin master
        success "Configuration mise à jour"
    else
        # Nettoyer le répertoire s'il existe
        rm -rf "$DEPLOY_DIR"
        mkdir -p "$DEPLOY_DIR"
        cd "$DEPLOY_DIR"

        # Cloner le repository
        git clone "$GITHUB_REPO" .
        success "Configuration téléchargée"
    fi
}

# Construction de l'image Docker
build_image() {
    info "Construction de l'image Docker..."

    cd "$DEPLOY_DIR"

    # Copier les fichiers pour le build Docker
    if [ -d "docker" ]; then
        # Builder l'image
        docker build -f docker/Dockerfile -t "$DOCKER_IMAGE:$VERSION" .
        success "Image Docker construite"
    else
        error "Fichiers Docker non trouvés"
        exit 1
    fi
}

# Configuration des variables d'environnement
setup_environment() {
    info "Configuration de l'environnement..."

    ENV_FILE="$DEPLOY_DIR/.env"

    # Demander le token GitHub si pas défini
    if [ -z "$GITHUB_TOKEN" ]; then
        echo ""
        echo "🔑 Configuration GitHub Token"
        echo "Créer un token: https://github.com/settings/tokens"
        echo "Permissions requises: repo, workflow, write:packages"
        echo ""
        read -p "GitHub Token (optionnel): " GITHUB_TOKEN
        echo ""
    fi

    # Créer le fichier .env
    cat > "$ENV_FILE" << EOF
# Claude Code CEO - Environment Configuration
GITHUB_TOKEN=$GITHUB_TOKEN
GITHUB_USER=ehadsagency-ai
GITHUB_EMAIL=ehads.agency@gmail.com
GITHUB_REPO=claude-code-memory
AUTO_SYNC=true
DEBUG_MODE=false
EOF

    success "Variables d'environnement configurées"
}

# Déploiement avec Docker Compose
deploy_with_compose() {
    info "Déploiement avec Docker Compose..."

    cd "$DEPLOY_DIR"

    # Utiliser docker-compose ou docker compose selon la version
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE="docker-compose"
    else
        DOCKER_COMPOSE="docker compose"
    fi

    # Démarrer les services
    $DOCKER_COMPOSE -f docker/docker-compose.yml up -d

    success "Services déployés"
}

# Vérification du déploiement
verify_deployment() {
    info "Vérification du déploiement..."

    # Attendre que le service soit prêt
    echo "⏳ Attente du démarrage du service..."
    sleep 10

    # Vérifier que le conteneur fonctionne
    if docker ps | grep -q "$CONTAINER_NAME"; then
        success "Conteneur en cours d'exécution"

        # Tester l'API
        if curl -s -f "http://localhost:5000/api/status" > /dev/null; then
            success "API accessible"
        else
            warning "API non accessible - le service démarre peut-être encore"
        fi
    else
        error "Conteneur non démarré"
        echo "📋 Logs du conteneur:"
        docker logs "$CONTAINER_NAME" 2>/dev/null || true
        exit 1
    fi
}

# Bannière DEO finale
show_deo_banner() {
    echo ""
    echo -e "${BLUE}"
    cat << 'EOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║    ██████╗ ███████╗ ██████╗     ███████╗██╗   ██╗███████╗████████╗███████╗ ║
║    ██╔══██╗██╔════╝██╔═══██╗    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝ ║
║    ██║  ██║█████╗  ██║   ██║    ███████╗ ╚████╔╝ ███████╗   ██║   █████╗   ║
║    ██║  ██║██╔══╝  ██║   ██║    ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝   ║
║    ██████╔╝███████╗╚██████╔╝    ███████║   ██║   ███████║   ██║   ███████╗ ║
║    ╚═════╝ ╚══════╝ ╚═════╝     ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝ ║
║                                                                            ║
║                    🚀 DIGITAL EXECUTIVE OFFICER 🚀                         ║
║                                                                            ║
║                    Enterprise Claude Code Configuration                    ║
║                           Global Memory System                             ║
║                        Hierarchical Agent Management                       ║
║                                                                            ║
║              👤 ehadsagency-ai  |  📧 ehads.agency@gmail.com               ║
║                                                                            ║
║    ✅ Docker Deployment: Active   🧠 CEO Memory: Operational               ║
║    ✅ Web Interface: Running      🔄 GitHub Sync: Configured               ║
║    ✅ Agent Systems: Ready        📊 Dashboard: http://localhost:5000      ║
║                                                                            ║
║               🌟 Your Professional Claude Code is Ready! 🌟               ║
║                                                                            ║
║    Management Commands:                                                    ║
║    • View Logs: docker logs -f claude-code-ceo                            ║
║    • Stop System: docker stop claude-code-ceo                             ║
║    • Access Shell: docker exec -it claude-code-ceo bash                   ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
    echo -e "${GREEN}    🎯 DEO DOCKER SYSTEM: FULLY OPERATIONAL${NC}"
    echo ""
    echo -e "${YELLOW}    Container: $(docker ps --format '{{.Status}}' -f name=claude-code-ceo)${NC}"
    echo ""
    echo -e "${RED}    🔥 Ready to manage enterprise development! 🔥${NC}"
    echo ""
}

# Affichage des informations finales
show_final_info() {
    show_deo_banner

    # Ouvrir le navigateur automatiquement
    if command -v open &> /dev/null; then
        open "http://localhost:5000"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:5000"
    fi
}

# Gestion des erreurs
handle_error() {
    error "Erreur lors du déploiement"
    echo "📋 Nettoyage en cours..."
    cleanup_previous
    exit 1
}

trap handle_error ERR

# Fonction principale
main() {
    echo "👤 Déploiement Claude Code CEO pour: ehadsagency-ai"
    echo "📧 Email: ehads.agency@gmail.com"
    echo ""

    check_prerequisites
    cleanup_previous
    download_config
    build_image
    setup_environment
    deploy_with_compose
    verify_deployment
    show_final_info
}

# Point d'entrée
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --help, -h     Afficher cette aide"
    echo "  --version, -v  Afficher la version"
    echo ""
    echo "Variables d'environnement:"
    echo "  GITHUB_TOKEN   Token d'authentification GitHub"
    echo ""
    exit 0
elif [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    echo "Claude Code CEO Deploy v1.0.0"
    exit 0
fi

# Exécuter le déploiement
main "$@"