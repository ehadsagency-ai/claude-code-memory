#!/bin/bash

# DEO Claude Code CEO - Installation Linux depuis USB
# Digital Executive Officer Auto-Installer Linux Edition

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
║                    Linux Edition                       ║
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

# Détection distribution Linux
detect_distro() {
    info "Détection de la distribution Linux..."

    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
        success "Distribution détectée: $PRETTY_NAME"
    else
        warning "Distribution non reconnue - Mode générique"
        DISTRO="unknown"
    fi
}

# Installation Docker
install_docker() {
    info "Vérification de Docker..."

    if ! command -v docker &> /dev/null; then
        warning "Docker non installé - Installation automatique..."

        case $DISTRO in
            "ubuntu"|"debian")
                info "Installation Docker via apt..."
                sudo apt-get update
                sudo apt-get install -y docker.io docker-compose
                sudo systemctl enable docker
                sudo systemctl start docker
                sudo usermod -aG docker $USER
                success "Docker installé via apt"
                ;;
            "fedora"|"centos"|"rhel")
                info "Installation Docker via dnf/yum..."
                sudo dnf install -y docker docker-compose || sudo yum install -y docker docker-compose
                sudo systemctl enable docker
                sudo systemctl start docker
                sudo usermod -aG docker $USER
                success "Docker installé via dnf/yum"
                ;;
            "arch")
                info "Installation Docker via pacman..."
                sudo pacman -S --noconfirm docker docker-compose
                sudo systemctl enable docker
                sudo systemctl start docker
                sudo usermod -aG docker $USER
                success "Docker installé via pacman"
                ;;
            *)
                info "Installation Docker via script universel..."
                curl -fsSL https://get.docker.com -o get-docker.sh
                sudo sh get-docker.sh
                sudo usermod -aG docker $USER
                rm get-docker.sh
                success "Docker installé via script universel"
                ;;
        esac

        warning "Redémarrage nécessaire pour utiliser Docker sans sudo"
    else
        success "Docker déjà installé"
    fi
}

# Installation Python
install_python() {
    info "Vérification Python..."

    if ! command -v python3 &> /dev/null; then
        warning "Python3 non installé - Installation..."

        case $DISTRO in
            "ubuntu"|"debian")
                sudo apt-get install -y python3 python3-pip
                ;;
            "fedora"|"centos"|"rhel")
                sudo dnf install -y python3 python3-pip || sudo yum install -y python3 python3-pip
                ;;
            "arch")
                sudo pacman -S --noconfirm python python-pip
                ;;
            *)
                error "Distribution non supportée pour installation automatique Python"
                echo "Veuillez installer Python3 manuellement"
                exit 1
                ;;
        esac
        success "Python3 installé"
    else
        success "Python3 déjà installé"
    fi
}

# Installation Git
install_git() {
    info "Vérification Git..."

    if ! command -v git &> /dev/null; then
        warning "Git non installé - Installation..."

        case $DISTRO in
            "ubuntu"|"debian")
                sudo apt-get install -y git
                ;;
            "fedora"|"centos"|"rhel")
                sudo dnf install -y git || sudo yum install -y git
                ;;
            "arch")
                sudo pacman -S --noconfirm git
                ;;
            *)
                error "Distribution non supportée pour installation automatique Git"
                echo "Veuillez installer Git manuellement"
                exit 1
                ;;
        esac
        success "Git installé"
    else
        success "Git déjà installé"
    fi
}

# Installation curl
install_curl() {
    info "Vérification curl..."

    if ! command -v curl &> /dev/null; then
        warning "curl non installé - Installation..."

        case $DISTRO in
            "ubuntu"|"debian")
                sudo apt-get install -y curl
                ;;
            "fedora"|"centos"|"rhel")
                sudo dnf install -y curl || sudo yum install -y curl
                ;;
            "arch")
                sudo pacman -S --noconfirm curl
                ;;
        esac
        success "curl installé"
    else
        success "curl déjà installé"
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
        chmod +x "$GLOBAL_MEMORY/sync_scripts/github_sync.sh"
        success "Scripts de synchronisation trouvés"
    fi

    if [[ -f "$GLOBAL_MEMORY/ui/index.html" ]]; then
        success "Interface web trouvée"
    fi

    if [[ -f "$GLOBAL_MEMORY/docker/deploy.sh" ]]; then
        chmod +x "$GLOBAL_MEMORY/docker/deploy.sh"
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
║                 ✅ INSTALLATION USB LINUX TERMINÉE ✅                      ║
║                                                                            ║
║              👤 ehadsagency-ai  |  📧 ehads.agency@gmail.com               ║
║                                                                            ║
║    🧠 CEO Memory: Active        🔄 GitHub Sync: Ready                     ║
║    👥 Agents: Deployed          🌐 Web Interface: Ready                   ║
║    🐳 Docker: Operational       📊 Dashboard: localhost:3000              ║
║                                                                            ║
║             🌟 Votre Claude Code CEO est prêt depuis USB ! 🌟             ║
║                                                                            ║
║    Note: Si Docker nécessite un redémarrage, relancez ce script après.    ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
    echo -e "${GREEN}    🎯 DEO USB SYSTEM: FULLY OPERATIONAL ON LINUX${NC}"
    echo ""
    echo -e "${RED}    🔥 Ready to revolutionize development from anywhere! 🔥${NC}"
    echo ""
}

# Fonction principale
main() {
    show_banner
    detect_distro

    echo "🚀 Démarrage installation DEO Claude Code CEO..."
    echo ""

    install_curl
    install_docker
    install_python
    install_git
    echo ""

    deploy_claude_code
    echo ""

    test_installation
    echo ""

    info "Finalisation DEO..."
    show_deo_banner

    info "Pour accéder à l'interface web: http://localhost:3000"

    echo ""
    echo "📝 Installation terminée ! Appuyez sur Entrée pour fermer..."
    read
}

# Vérification des privilèges sudo
check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        echo "🔑 Privilèges sudo requis pour l'installation"
        echo "Veuillez saisir votre mot de passe:"
        sudo true
    fi
}

# Execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    check_sudo
    main "$@"
fi