#!/bin/bash

# Personal Claude Code Installation Script
# This script sets up your personalized Claude Code environment with all configurations

set -e

echo "🚀 INSTALLATION CLAUDE CODE PERSONNEL"
echo "====================================="
echo "👤 Utilisateur: ehadsagency-ai"
echo "📧 Email: ehads.agency@gmail.com"
echo ""

# Configuration directories
CLAUDE_DIR="$HOME/.claude"
MEMORY_DIR="$CLAUDE_DIR/global_memory"
GITHUB_REPO="claude-code-memory"
GITHUB_USER="ehadsagency-ai"

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code n'est pas installé"
    echo "💡 Veuillez d'abord installer Claude Code depuis https://claude.ai/code"
    exit 1
fi

echo "✅ Claude Code détecté"

# Function to setup GitHub credentials
setup_github_credentials() {
    echo ""
    echo "🔐 CONFIGURATION GITHUB"
    echo "========================"

    if [ -f "$CLAUDE_DIR/github_credentials" ]; then
        echo "✅ Credentials GitHub déjà configurés"
        source "$CLAUDE_DIR/github_credentials"
        echo "👤 User: $GITHUB_USER"
        echo "🔑 Token: ${GITHUB_TOKEN:0:10}..."
    else
        echo "⚠️  Credentials GitHub non configurés"
        echo ""
        echo "🔧 Étapes requises:"
        echo "1. Aller sur: https://github.com/settings/tokens"
        echo "2. Créer un token avec permissions 'repo'"
        echo "3. Copier le template: cp $CLAUDE_DIR/github_credentials_template $CLAUDE_DIR/github_credentials"
        echo "4. Éditer le fichier avec votre token"
        echo "5. Relancer ce script"
        echo ""
        return 1
    fi
}

# Function to clone or update memory repository
setup_memory_repository() {
    echo ""
    echo "🧠 CONFIGURATION MÉMOIRE GLOBALE"
    echo "================================="

    if [ -d "$MEMORY_DIR/.git" ]; then
        echo "📥 Mise à jour de la mémoire existante..."
        cd "$MEMORY_DIR"
        git pull origin main || git pull origin master
        echo "✅ Mémoire mise à jour"
    else
        echo "📥 Clonage de votre mémoire personnelle..."
        if [ -d "$MEMORY_DIR" ]; then
            mv "$MEMORY_DIR" "${MEMORY_DIR}.backup.$(date +%s)"
            echo "🔄 Ancien répertoire sauvegardé"
        fi

        REPO_URL="https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$GITHUB_REPO.git"
        git clone "$REPO_URL" "$MEMORY_DIR"
        echo "✅ Mémoire clonée"
    fi
}

# Function to setup local configurations
setup_local_configurations() {
    echo ""
    echo "⚙️  CONFIGURATION LOCALE"
    echo "========================"

    # Ensure directory structure
    mkdir -p "$MEMORY_DIR"/{error_patterns,architectures,optimizations,project_templates,decision_history}
    mkdir -p "$MEMORY_DIR"/{sync_scripts,setup_guides,install_scripts}

    # Set permissions
    chmod +x "$MEMORY_DIR"/sync_scripts/*.sh 2>/dev/null || true
    chmod +x "$MEMORY_DIR"/install_scripts/*.sh 2>/dev/null || true

    echo "✅ Structure de répertoires configurée"
    echo "✅ Permissions définies"
}

# Function to test the installation
test_installation() {
    echo ""
    echo "🧪 TEST DE L'INSTALLATION"
    echo "========================="

    # Test memory access
    if [ -d "$MEMORY_DIR" ]; then
        MEMORY_SIZE=$(du -sh "$MEMORY_DIR" | cut -f1)
        MEMORY_FILES=$(find "$MEMORY_DIR" -type f | wc -l)
        echo "✅ Mémoire accessible: $MEMORY_SIZE ($MEMORY_FILES fichiers)"
    else
        echo "❌ Mémoire non accessible"
        return 1
    fi

    # Test GitHub sync
    if [ -f "$MEMORY_DIR/sync_scripts/github_sync.sh" ]; then
        echo "✅ Script de synchronisation disponible"
        if "$MEMORY_DIR/sync_scripts/github_sync.sh" status >/dev/null 2>&1; then
            echo "✅ Synchronisation GitHub opérationnelle"
        else
            echo "⚠️  Synchronisation GitHub à configurer"
        fi
    else
        echo "⚠️  Script de synchronisation manquant"
    fi

    # Test agent configurations
    if [ -f "$CLAUDE_DIR/agents.json" ]; then
        AGENT_COUNT=$(grep -c '"description"' "$CLAUDE_DIR/agents.json" 2>/dev/null || echo "0")
        echo "✅ Agents configurés: $AGENT_COUNT"
    else
        echo "⚠️  Configuration agents manquante"
    fi
}

# Function to show final instructions
show_final_instructions() {
    echo ""
    echo "🎯 INSTALLATION TERMINÉE"
    echo "========================"
    echo ""
    echo "📋 Commandes disponibles:"
    echo "   /ceo        - Orchestrateur CEO avec mémoire globale"
    echo "   /memory     - Accès direct à la mémoire globale"
    echo "   /cto        - Leadership technique"
    echo "   /cro        - Leadership recherche/compliance"
    echo ""
    echo "🔄 Synchronisation:"
    echo "   ~/.claude/global_memory/sync_scripts/github_sync.sh sync"
    echo ""
    echo "📊 Status mémoire:"
    echo "   ~/.claude/global_memory/sync_scripts/github_sync.sh status"
    echo ""
    echo "🎉 Votre Claude Code personnel est prêt !"
    echo "   Tous vos patterns et configurations sont disponibles"
}

# Main installation flow
main() {
    # Setup GitHub credentials
    if ! setup_github_credentials; then
        echo "❌ Configuration GitHub requise avant installation"
        exit 1
    fi

    # Setup memory repository
    setup_memory_repository

    # Setup local configurations
    setup_local_configurations

    # Test installation
    test_installation

    # Show final instructions
    show_final_instructions
}

# Run installation
main "$@"