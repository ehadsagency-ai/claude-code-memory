#!/bin/bash

# Claude Code CEO - One-Click Install via URL
# Installation ultra-simple en une commande via curl/wget

set -e

# Configuration
REPO_URL="https://raw.githubusercontent.com/ehadsagency-ai/claude-code-memory/main"
DEPLOY_SCRIPT="$REPO_URL/docker/deploy.sh"
INSTALLER_NAME="Claude Code CEO One-Click Installer"
VERSION="1.0.0"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Banner
show_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
  ╔═══════════════════════════════════════════════════════════╗
  ║                                                           ║
  ║            🧠 CLAUDE CODE CEO INSTALLER 🧠                ║
  ║                                                           ║
  ║        Professional Configuration Manager                 ║
  ║              One-Click Docker Deployment                  ║
  ║                                                           ║
  ║              👤 ehadsagency-ai                            ║
  ║              📧 ehads.agency@gmail.com                    ║
  ║                                                           ║
  ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
    echo -e "${GREEN}Version: $VERSION${NC}"
    echo ""
}

# Fonction de logging
log() {
    echo -e "[$(date '+%H:%M:%S')] $1"
}

success() {
    log "${GREEN}✅ $1${NC}"
}

info() {
    log "${BLUE}ℹ️  $1${NC}"
}

warning() {
    log "${YELLOW}⚠️  $1${NC}"
}

error() {
    log "${RED}❌ $1${NC}"
}

# Vérification de l'outil de téléchargement
check_download_tool() {
    if command -v curl &> /dev/null; then
        DOWNLOAD_CMD="curl -fsSL"
        success "curl détecté"
    elif command -v wget &> /dev/null; then
        DOWNLOAD_CMD="wget -qO-"
        success "wget détecté"
    else
        error "Aucun outil de téléchargement trouvé (curl ou wget requis)"
        echo ""
        echo "💡 Installer curl:"
        echo "   macOS: brew install curl"
        echo "   Ubuntu/Debian: apt-get install curl"
        echo "   CentOS/RHEL: yum install curl"
        echo ""
        exit 1
    fi
}

# Vérification de Docker
check_docker() {
    info "Vérification de Docker..."

    if ! command -v docker &> /dev/null; then
        warning "Docker n'est pas installé"
        echo ""
        echo "🐳 Installation automatique de Docker?"
        read -p "Installer Docker maintenant? (o/N): " install_docker

        if [[ $install_docker =~ ^[Oo]$ ]]; then
            install_docker_auto
        else
            echo ""
            echo "📋 Installer Docker manuellement:"
            echo "   Site officiel: https://docs.docker.com/get-docker/"
            echo ""
            echo "⚡ Installation rapide:"
            echo "   macOS: brew install --cask docker"
            echo "   Linux: curl -fsSL https://get.docker.com | sh"
            echo ""
            exit 1
        fi
    else
        success "Docker installé"
    fi

    # Vérifier que Docker fonctionne
    if ! docker ps &> /dev/null; then
        warning "Docker n'est pas démarré"
        echo ""
        echo "🚀 Démarrer Docker:"
        echo "   macOS: Ouvrir Docker Desktop"
        echo "   Linux: sudo systemctl start docker"
        echo ""
        exit 1
    fi

    success "Docker opérationnel"
}

# Installation automatique de Docker (Linux)
install_docker_auto() {
    info "Installation automatique de Docker..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -fsSL https://get.docker.com | sh
        sudo usermod -aG docker $USER
        sudo systemctl start docker
        sudo systemctl enable docker
        success "Docker installé (redémarrage de session requis)"

        echo ""
        warning "Redémarrage de session requis"
        echo "Exécuter: newgrp docker"
        echo "Puis relancer ce script"
        exit 0

    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install --cask docker
            success "Docker Desktop installé"
            echo ""
            info "Ouvrir Docker Desktop manuellement et relancer ce script"
            exit 0
        else
            error "Homebrew requis pour installation automatique sur macOS"
            echo "Installer depuis: https://docs.docker.com/desktop/mac/install/"
            exit 1
        fi
    else
        error "Installation automatique non supportée pour $OSTYPE"
        echo "Installer depuis: https://docs.docker.com/get-docker/"
        exit 1
    fi
}

# Téléchargement et exécution du script de déploiement
download_and_deploy() {
    info "Téléchargement du script de déploiement..."

    # Télécharger le script
    TEMP_SCRIPT=$(mktemp)

    if $DOWNLOAD_CMD "$DEPLOY_SCRIPT" > "$TEMP_SCRIPT"; then
        success "Script de déploiement téléchargé"
        chmod +x "$TEMP_SCRIPT"

        # Exécuter le déploiement
        info "Lancement du déploiement..."
        echo ""

        bash "$TEMP_SCRIPT"

        # Nettoyer
        rm -f "$TEMP_SCRIPT"

    else
        error "Impossible de télécharger le script de déploiement"
        echo ""
        echo "📋 Téléchargement manuel:"
        echo "   URL: $DEPLOY_SCRIPT"
        echo ""
        exit 1
    fi
}

# Configuration du token GitHub (optionnel)
setup_github_token() {
    echo ""
    echo -e "${YELLOW}🔑 CONFIGURATION GITHUB TOKEN${NC}"
    echo "══════════════════════════════════"
    echo ""
    echo "Pour synchroniser vos configurations personnelles:"
    echo "1. Créer un token: https://github.com/settings/tokens"
    echo "2. Permissions: repo, workflow, write:packages"
    echo "3. Copier le token généré"
    echo ""

    read -p "Avez-vous un token GitHub? (o/N): " has_token

    if [[ $has_token =~ ^[Oo]$ ]]; then
        read -s -p "Token GitHub: " GITHUB_TOKEN
        echo ""
        export GITHUB_TOKEN
        success "Token GitHub configuré"
    else
        info "Déploiement sans synchronisation GitHub"
        echo "💡 Vous pourrez configurer le token plus tard via l'interface web"
    fi
    echo ""
}

# Information finale
show_final_info() {
    echo ""
    echo -e "${GREEN}🎉 INSTALLATION TERMINÉE !${NC}"
    echo "=========================="
    echo ""
    echo "🌐 Interface Claude Code CEO disponible sur:"
    echo "   http://localhost:5000"
    echo ""
    echo "✨ Fonctionnalités activées:"
    echo "   🔐 Configuration GitHub Token"
    echo "   🧠 Gestion Mémoire Globale CEO"
    echo "   👥 Hiérarchie Agents (CEO/CTO/CRO)"
    echo "   📊 Dashboard Professionnel"
    echo "   🔄 Synchronisation Automatique"
    echo ""
    echo "🚀 Votre Claude Code niveau ENTREPRISE est prêt !"
    echo ""
}

# Gestion des erreurs
handle_error() {
    error "Erreur lors de l'installation"
    echo ""
    echo "🆘 Support:"
    echo "   GitHub: https://github.com/ehadsagency-ai/claude-code-memory/issues"
    echo "   Email: ehads.agency@gmail.com"
    echo ""
    exit 1
}

trap handle_error ERR

# Fonction principale
main() {
    show_banner

    info "Démarrage de l'installation one-click..."
    echo ""

    check_download_tool
    check_docker
    setup_github_token
    download_and_deploy
    show_final_info
}

# Affichage de l'aide
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_banner
    echo "USAGE:"
    echo "   curl -fsSL https://raw.githubusercontent.com/ehadsagency-ai/claude-code-memory/main/docker/one-click-install.sh | bash"
    echo ""
    echo "OU:"
    echo "   wget -qO- https://raw.githubusercontent.com/ehadsagency-ai/claude-code-memory/main/docker/one-click-install.sh | bash"
    echo ""
    echo "OPTIONS:"
    echo "   --help, -h     Afficher cette aide"
    echo "   --version, -v  Afficher la version"
    echo ""
    echo "VARIABLES D'ENVIRONNEMENT:"
    echo "   GITHUB_TOKEN   Token d'authentification GitHub (optionnel)"
    echo ""
    echo "PRÉREQUIS:"
    echo "   - Docker (installation automatique possible)"
    echo "   - curl ou wget"
    echo ""
    exit 0
fi

if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    echo "$INSTALLER_NAME v$VERSION"
    exit 0
fi

# Exécuter l'installation
main "$@"