#!/bin/bash

# DEO Smart USB - Menu de Sélection Linux
# Digital Executive Officer - Clé USB Intelligente

set -e

# Dossier de ce script
USB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Couleurs pour l'affichage
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Détection de la distribution
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
    else
        DISTRO="unknown"
    fi
}

# Fonction pour afficher le menu principal
show_main_menu() {
    clear
    echo -e "${BLUE}"
    cat << 'EOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║    🚀 DEO SMART USB - MODE SELECTION 🚀                                   ║
║                                                                            ║
║                    Digital Executive Officer                               ║
║                      Clé USB Intelligente                                 ║
║                                                                            ║
║              👤 ehadsagency-ai  |  📧 ehads.agency@gmail.com               ║
║                                                                            ║
╠════════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  Choisissez votre mode d'utilisation:                                     ║
║                                                                            ║
║  [1] 🗂️  Mode USB Standard                                               ║
║      → Accès normal aux fichiers et dossiers                              ║
║      → Utilisation comme clé USB classique                                ║
║                                                                            ║
║  [2] 🧠 Mode Claude Code DEO                                              ║
║      → Installation système Claude Code CEO                               ║
║      → Configuration enterprise complète                                  ║
║                                                                            ║
║  [3] ⚙️  Configuration DEO Avancée                                        ║
║      → Paramètres système DEO                                             ║
║      → Gestion credentials GitHub                                         ║
║                                                                            ║
║  [4] 📖 Documentation                                                     ║
║      → Guide d'utilisation complet                                        ║
║      → Instructions détaillées                                            ║
║                                                                            ║
║  [0] ❌ Quitter                                                            ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""

    # Affichage informations système
    echo -e "${YELLOW}💻 Système:${NC} $PRETTY_NAME"
    echo -e "${YELLOW}💾 Espace USB:${NC}"
    df -h "$USB_ROOT" | tail -1 | awk '{print "   Disponible: " $4 " / " $2}'
    echo ""
}

# Mode USB Standard
mode_usb_standard() {
    clear
    echo -e "${GREEN}"
    cat << 'EOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║    🗂️  MODE USB STANDARD ACTIVÉ 🗂️                                       ║
║                                                                            ║
║    ✅ Accès normal à vos fichiers                                         ║
║    ✅ Fonctionnement clé USB classique                                    ║
║    ✅ Système DEO reste en arrière-plan                                   ║
║                                                                            ║
║    📁 Dossiers disponibles:                                               ║
║    • Documents/     - Vos documents                                       ║
║    • Images/        - Vos photos et images                                ║
║    • Projects/      - Vos projets de développement                        ║
║    • Archive/       - Vos fichiers archivés                               ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
    echo "🚀 Ouverture du gestionnaire de fichiers..."
    echo ""

    # Ouvrir le gestionnaire de fichiers selon l'environnement
    if command -v nautilus &> /dev/null; then
        nautilus "$USB_ROOT" &
        echo "📂 Nautilus ouvert sur votre clé USB DEO."
    elif command -v dolphin &> /dev/null; then
        dolphin "$USB_ROOT" &
        echo "📂 Dolphin ouvert sur votre clé USB DEO."
    elif command -v thunar &> /dev/null; then
        thunar "$USB_ROOT" &
        echo "📂 Thunar ouvert sur votre clé USB DEO."
    elif command -v pcmanfm &> /dev/null; then
        pcmanfm "$USB_ROOT" &
        echo "📂 PCManFM ouvert sur votre clé USB DEO."
    else
        echo "📂 Gestionnaire de fichiers par défaut:"
        echo "   Dossier: $USB_ROOT"
        ls -la "$USB_ROOT"
    fi

    echo ""
    echo "💡 Pour accéder au mode DEO plus tard, relancez ce menu."
    echo ""
    echo "Appuyez sur Entrée pour continuer..."
    read
}

# Mode Claude Code DEO
mode_claude_code_deo() {
    clear
    echo -e "${MAGENTA}"
    cat << 'EOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║    🧠 MODE CLAUDE CODE DEO ACTIVÉ 🧠                                      ║
║                                                                            ║
║    🚀 Démarrage installation Digital Executive Officer...                  ║
║                                                                            ║
║    ⏳ Préparation du système enterprise...                                ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
    echo "🔄 Lancement du système d'installation DEO..."
    echo ""

    # Vérifier les privilèges sudo
    if ! sudo -n true 2>/dev/null; then
        echo "🔑 Privilèges sudo requis pour l'installation DEO"
        echo "Veuillez saisir votre mot de passe:"
        sudo true
    fi

    # Lancer le script d'installation DEO
    if [[ -f "$USB_ROOT/.deo_system/scripts/DEMARRER_DEO_LINUX.sh" ]]; then
        bash "$USB_ROOT/.deo_system/scripts/DEMARRER_DEO_LINUX.sh"
    else
        echo -e "${RED}❌ Script d'installation DEO non trouvé${NC}"
        echo "Vérifiez que la clé USB contient les fichiers DEO."
    fi

    echo ""
    echo "Appuyez sur Entrée pour continuer..."
    read
}

# Configuration DEO Avancée
config_deo_advanced() {
    while true; do
        clear
        echo -e "${CYAN}"
        cat << 'EOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║    ⚙️  CONFIGURATION DEO AVANCÉE ⚙️                                       ║
║                                                                            ║
║    [1] 🔧 Paramètres système                                              ║
║    [2] 🔑 Configuration GitHub                                             ║
║    [3] 🧠 Gestion mémoire CEO                                             ║
║    [4] 📊 Statistiques système                                            ║
║    [5] 🔄 Test synchronisation                                            ║
║    [6] 🛠️  Diagnostic système                                             ║
║                                                                            ║
║    [9] ⬅️  Retour menu principal                                          ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
        echo -e "${NC}"
        echo ""

        read -p "🎯 Configuration [1-6, 9]: " configchoice

        case $configchoice in
            1)
                echo "🔧 Configuration système DEO:"
                if [[ -f "$USB_ROOT/.deo_system/core/memory_config.json" ]]; then
                    echo "✅ Fichier de configuration trouvé:"
                    head -10 "$USB_ROOT/.deo_system/core/memory_config.json"
                    echo ""
                    read -p "Ouvrir avec éditeur? (o/N): " edit
                    if [[ $edit =~ ^[Oo]$ ]]; then
                        ${EDITOR:-nano} "$USB_ROOT/.deo_system/core/memory_config.json"
                    fi
                else
                    echo "❌ Fichier de configuration non trouvé"
                fi
                echo ""
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            2)
                echo "🔑 Configuration GitHub:"
                if [[ -f "$USB_ROOT/.deo_system/data/user-configs/github_credentials" ]]; then
                    echo "✅ Credentials GitHub trouvés:"
                    cat "$USB_ROOT/.deo_system/data/user-configs/github_credentials" | sed 's/ghp_[a-zA-Z0-9]*/ghp_***MASKED***/g'
                else
                    echo "❌ Pas de credentials configurés"
                    echo "💡 Lancez le mode DEO pour configurer GitHub"
                fi
                echo ""
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            3)
                echo "🧠 Gestion mémoire CEO:"
                if [[ -d "$USB_ROOT/.deo_system/core" ]]; then
                    echo "📊 Taille configuration: $(du -sh "$USB_ROOT/.deo_system/core" | cut -f1)"
                    echo "📁 Nombre de fichiers: $(find "$USB_ROOT/.deo_system/core" -type f | wc -l)"
                    echo "🗂️  Dossiers principaux:"
                    ls -la "$USB_ROOT/.deo_system/core" | grep '^d' | awk '{print "   • " $9}'
                else
                    echo "❌ Configuration DEO non trouvée"
                fi
                echo ""
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            4)
                echo "📊 Statistiques système DEO:"
                echo "💻 Distribution: $PRETTY_NAME"
                echo "💾 Espace USB: $(df -h "$USB_ROOT" | tail -1 | awk '{print $4 " disponible sur " $2}')"
                echo "🕐 Montage: $(mount | grep "$(df "$USB_ROOT" | tail -1 | awk '{print $1}')" | awk '{print $3 " (" $5 " " $6 ")"}')"
                echo "📁 Contenu racine: $(ls "$USB_ROOT" | wc -l) éléments"
                echo ""
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            5)
                echo "🔄 Test synchronisation GitHub..."
                if [[ -f "$USB_ROOT/.deo_system/core/sync_scripts/github_sync.sh" ]]; then
                    bash "$USB_ROOT/.deo_system/core/sync_scripts/github_sync.sh" status
                else
                    echo "❌ Scripts de synchronisation non trouvés"
                fi
                echo ""
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            6)
                echo "🛠️  Diagnostic système:"
                echo "🔍 Vérification des dépendances:"

                # Vérifier Docker
                if command -v docker &> /dev/null; then
                    echo "✅ Docker: $(docker --version 2>/dev/null || echo 'Installé mais service arrêté')"
                else
                    echo "❌ Docker: Non installé"
                fi

                # Vérifier Python
                if command -v python3 &> /dev/null; then
                    echo "✅ Python: $(python3 --version)"
                else
                    echo "❌ Python3: Non installé"
                fi

                # Vérifier Git
                if command -v git &> /dev/null; then
                    echo "✅ Git: $(git --version)"
                else
                    echo "❌ Git: Non installé"
                fi

                # Vérifier curl
                if command -v curl &> /dev/null; then
                    echo "✅ curl: $(curl --version | head -1)"
                else
                    echo "❌ curl: Non installé"
                fi

                echo ""
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            9)
                break
                ;;
            *)
                echo "❌ Choix invalide !"
                sleep 1
                ;;
        esac
    done
}

# Documentation
show_documentation() {
    clear
    echo -e "${GREEN}"
    cat << 'EOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║    📖 DOCUMENTATION DEO SMART USB 📖                                      ║
║                                                                            ║
║    📚 Guides disponibles:                                                 ║
║                                                                            ║
║    • README.md                  - Guide principal                          ║
║    • GUIDE_UTILISATION_USB.md   - Mode d'emploi détaillé                  ║
║                                                                            ║
║    🌐 Ressources en ligne:                                                ║
║    • https://github.com/ehadsagency-ai/claude-code-memory                 ║
║    • ehads.agency@gmail.com                                               ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""

    echo "📖 Documentation disponible:"
    if [[ -f "$USB_ROOT/README.md" ]]; then
        echo "✅ README.md trouvé"
        read -p "Afficher le README? (o/N): " show
        if [[ $show =~ ^[Oo]$ ]]; then
            less "$USB_ROOT/README.md"
        fi
    fi

    if [[ -f "$USB_ROOT/GUIDE_UTILISATION_USB.md" ]]; then
        echo "✅ GUIDE_UTILISATION_USB.md trouvé"
        read -p "Afficher le guide d'utilisation? (o/N): " show
        if [[ $show =~ ^[Oo]$ ]]; then
            less "$USB_ROOT/GUIDE_UTILISATION_USB.md"
        fi
    fi

    echo ""
    echo "Appuyez sur Entrée pour continuer..."
    read
}

# Fonction principale
main() {
    detect_distro

    while true; do
        show_main_menu

        read -p "🎯 Votre choix [1-4, 0]: " choice

        case $choice in
            1)
                mode_usb_standard
                ;;
            2)
                mode_claude_code_deo
                ;;
            3)
                config_deo_advanced
                ;;
            4)
                show_documentation
                ;;
            0)
                clear
                echo -e "${BLUE}"
                cat << 'EOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║    👋 Au revoir !                                                          ║
║                                                                            ║
║    Votre DEO Smart USB est toujours disponible.                           ║
║    Relancez ce menu quand vous voulez !                                    ║
║                                                                            ║
║    🚀 Digital Executive Officer - ehadsagency-ai                           ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
                echo -e "${NC}"
                echo ""
                echo "Fermeture du menu..."
                sleep 2
                exit 0
                ;;
            *)
                echo ""
                echo -e "${RED}❌ Choix invalide ! Appuyez sur Entrée pour recommencer...${NC}"
                read
                ;;
        esac
    done
}

# Exécution du script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi