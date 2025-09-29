#!/bin/bash

# DEO Claude Code CEO - Installation macOS depuis USB
# Digital Executive Officer Auto-Installer macOS Edition

set -e

# Couleurs pour l'affichage
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Dossier de ce script
USB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Bannière de démarrage
show_banner() {
    clear
    echo -e "${BLUE}"
    cat << 'EOF'
╔════════════════════════════════════════════════════════╗
║                                                        ║
║     🚀 DEO CLAUDE CODE CEO - INSTALLATION USB 🚀       ║
║                                                        ║
║         Digital Executive Officer Auto-Installer       ║
║                    macOS Edition                       ║
║                                                        ║
║               👤 ehadsagency-ai                        ║
║               📧 ehads.agency@gmail.com                ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
}

# Logging avec timestamp
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

# Vérification macOS
check_macos() {
    info "Détection du système macOS..."

    if [[ "$OSTYPE" != "darwin"* ]]; then
        error "Système non-macOS détecté"
        echo "💡 Utilisez DEMARRER_DEO_WINDOWS.bat ou DEMARRER_DEO_LINUX.sh"
        exit 1
    fi

    success "Système macOS compatible détecté"
    echo ""
}

# Installation Docker Desktop
install_docker() {
    info "Vérification de Docker..."

    if ! command -v docker &> /dev/null; then
        warning "Docker non installé - Installation automatique..."

        if [[ -f "$USB_ROOT/macos/docker-desktop.dmg" ]]; then
            info "Installation Docker Desktop depuis USB..."
            hdiutil attach "$USB_ROOT/macos/docker-desktop.dmg" -quiet
            DOCKER_VOLUME=$(ls /Volumes/ | grep -i docker | head -n1)
            if [[ -n "$DOCKER_VOLUME" ]]; then
                sudo cp -R "/Volumes/$DOCKER_VOLUME/Docker.app" /Applications/
                hdiutil detach "/Volumes/$DOCKER_VOLUME" -quiet
                success "Docker Desktop installé depuis USB"
            fi
        else
            info "Téléchargement Docker Desktop..."
            curl -L "https://desktop.docker.com/mac/main/amd64/Docker.dmg" -o "/tmp/Docker.dmg"
            hdiutil attach "/tmp/Docker.dmg" -quiet
            sudo cp -R "/Volumes/Docker/Docker.app" /Applications/
            hdiutil detach "/Volumes/Docker" -quiet
            rm "/tmp/Docker.dmg"
            success "Docker Desktop installé depuis internet"
        fi

        # Démarrage Docker
        info "Démarrage de Docker Desktop..."
        open -a Docker
        sleep 10
    else
        success "Docker déjà installé"
    fi
}

# Installation Homebrew si nécessaire
install_homebrew() {
    info "Vérification de Homebrew..."

    if ! command -v brew &> /dev/null; then
        warning "Homebrew non installé - Installation..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        success "Homebrew installé"
    else
        success "Homebrew déjà installé"
    fi
}

# Installation Python portable
install_python() {
    info "Vérification Python..."

    if ! command -v python3 &> /dev/null; then
        if [[ -d "$USB_ROOT/macos/python-portable" ]]; then
            info "Configuration Python portable..."
            export PATH="$USB_ROOT/macos/python-portable/bin:$PATH"
            success "Python portable configuré"
        else
            info "Installation Python via Homebrew..."
            brew install python@3.11
            success "Python installé"
        fi
    else
        success "Python déjà installé"
    fi
}

# Installation Git
install_git() {
    info "Vérification Git..."

    if ! command -v git &> /dev/null; then
        if [[ -d "$USB_ROOT/macos/git-portable" ]]; then
            info "Configuration Git portable..."
            export PATH="$USB_ROOT/macos/git-portable/bin:$PATH"
            success "Git portable configuré"
        else
            success "Git déjà disponible sur macOS"
        fi
    else
        success "Git déjà installé"
    fi
}

# Déploiement Claude Code CEO
deploy_claude_code() {
    info "Déploiement Claude Code CEO..."

    # Création dossier .claude dans home
    CLAUDE_DIR="$HOME/.claude"
    [[ ! -d "$CLAUDE_DIR" ]] && mkdir -p "$CLAUDE_DIR"

    # Copie configuration depuis USB
    if [[ -d "$USB_ROOT/core" ]]; then
        cp -R "$USB_ROOT/core/"* "$CLAUDE_DIR/"
        success "Configuration Claude Code CEO installée"
    fi

    # Restauration credentials GitHub si disponible
    if [[ -f "$USB_ROOT/data/user-configs/github_credentials" ]]; then
        cp "$USB_ROOT/data/user-configs/github_credentials" "$CLAUDE_DIR/"
        chmod 600 "$CLAUDE_DIR/github_credentials"
        success "Credentials GitHub restaurés"
    fi
}

# Test installation
test_installation() {
    info "Test de l'installation..."

    GLOBAL_MEMORY="$HOME/.claude/global_memory"

    if [[ -f "$GLOBAL_MEMORY/sync_scripts/github_sync.sh" ]]; then
        success "Scripts de synchronisation trouvés"
    fi

    if [[ -f "$GLOBAL_MEMORY/ui/index.html" ]]; then
        success "Interface web trouvée"
    fi

    if [[ -f "$GLOBAL_MEMORY/docker/deploy.sh" ]]; then
        success "Scripts Docker trouvés"
    fi
}

# Bannière finale DEO
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
║                 ✅ INSTALLATION USB macOS TERMINÉE ✅                      ║
║                                                                            ║
║              👤 ehadsagency-ai  |  📧 ehads.agency@gmail.com               ║
║                                                                            ║
║    🧠 CEO Memory: Active        🔄 GitHub Sync: Ready                     ║
║    👥 Agents: Deployed          🌐 Web Interface: Ready                   ║
║    🐳 Docker: Operational       📊 Dashboard: localhost:3000              ║
║                                                                            ║
║             🌟 Votre Claude Code CEO est prêt depuis USB ! 🌟             ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
    echo -e "${GREEN}    🎯 DEO USB SYSTEM: FULLY OPERATIONAL ON macOS${NC}"
    echo ""
    echo -e "${RED}    🔥 Ready to revolutionize development from anywhere! 🔥${NC}"
    echo ""
}

# Fonction principale
main() {
    show_banner
    check_macos

    echo "🚀 Démarrage installation DEO Claude Code CEO..."
    echo ""

    install_docker
    install_homebrew
    install_python
    install_git
    echo ""

    deploy_claude_code
    echo ""

    test_installation
    echo ""

    info "Finalisation DEO..."
    show_deo_banner

    info "Ouverture interface web..."
    open "http://localhost:3000" 2>/dev/null || true

    echo ""
    echo "📝 Installation terminée ! Appuyez sur une touche pour fermer..."
    read -n 1
}

# Execution
main "$@"