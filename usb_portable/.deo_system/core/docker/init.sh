#!/bin/bash

# Claude Code CEO - Docker Initialization Script
# Ce script prépare l'environnement Docker pour l'interface professionnelle

set -e

echo "🐳 CLAUDE CODE CEO - DOCKER INITIALIZATION"
echo "=========================================="
echo ""

# Variables d'environnement
CLAUDE_HOME="/app/.claude"
MEMORY_DIR="$CLAUDE_HOME/global_memory"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
AUTO_SYNC="${AUTO_SYNC:-true}"
DEBUG_MODE="${DEBUG_MODE:-false}"

echo "📁 Répertoire Claude: $CLAUDE_HOME"
echo "🧠 Répertoire Mémoire: $MEMORY_DIR"
echo "🔄 Auto-sync: $AUTO_SYNC"

# Fonction de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Vérification de l'environnement
check_environment() {
    log "🔍 Vérification de l'environnement..."

    # Vérifier Python
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
        log "✅ Python $PYTHON_VERSION détecté"
    else
        log "❌ Python non trouvé"
        exit 1
    fi

    # Vérifier Flask
    if python3 -c "import flask" 2>/dev/null; then
        log "✅ Flask installé"
    else
        log "❌ Flask non installé"
        exit 1
    fi

    # Vérifier la structure des répertoires
    if [ -d "$MEMORY_DIR" ]; then
        log "✅ Structure mémoire présente"
    else
        log "❌ Structure mémoire manquante"
        exit 1
    fi
}

# Configuration GitHub automatique
setup_github_config() {
    log "🔐 Configuration GitHub..."

    CREDENTIALS_FILE="$CLAUDE_HOME/github_credentials"

    if [ -n "$GITHUB_TOKEN" ]; then
        log "🔑 Token GitHub fourni via variable d'environnement"
        cat > "$CREDENTIALS_FILE" << EOF
# Configuration GitHub pour Claude Code CEO Memory (Docker)
GITHUB_TOKEN=$GITHUB_TOKEN
GITHUB_USER=$GITHUB_USER
GITHUB_EMAIL=$GITHUB_EMAIL
GITHUB_REPO=$GITHUB_REPO
EOF
        chmod 600 "$CREDENTIALS_FILE"
        log "✅ Credentials GitHub configurés"
    else
        log "⚠️  Token GitHub non fourni - Configuration manuelle requise"
    fi
}

# Synchronisation automatique depuis GitHub
auto_sync_memory() {
    if [ "$AUTO_SYNC" = "true" ] && [ -n "$GITHUB_TOKEN" ]; then
        log "🔄 Synchronisation automatique depuis GitHub..."

        SYNC_SCRIPT="$MEMORY_DIR/sync_scripts/github_sync.sh"
        if [ -f "$SYNC_SCRIPT" ]; then
            # Sourcer les credentials
            if [ -f "$CLAUDE_HOME/github_credentials" ]; then
                source "$CLAUDE_HOME/github_credentials"
            fi

            # Tenter la synchronisation
            if "$SYNC_SCRIPT" pull 2>/dev/null; then
                log "✅ Mémoire synchronisée depuis GitHub"
            else
                log "⚠️  Synchronisation impossible - utilisation configuration locale"
            fi
        else
            log "⚠️  Script de synchronisation non trouvé"
        fi
    else
        log "ℹ️  Synchronisation automatique désactivée"
    fi
}

# Préparation des logs
setup_logging() {
    log "📝 Configuration des logs..."

    LOG_DIR="/app/logs"
    mkdir -p "$LOG_DIR"

    # Redirection des logs si pas en mode debug
    if [ "$DEBUG_MODE" = "false" ]; then
        exec > >(tee -a "$LOG_DIR/claude-ceo.log")
        exec 2> >(tee -a "$LOG_DIR/claude-ceo-error.log")
    fi

    log "✅ Logs configurés dans $LOG_DIR"
}

# Configuration réseau
setup_network() {
    log "🌐 Configuration réseau..."

    # Vérifier la connectivité externe
    if curl -s --connect-timeout 5 https://api.github.com/rate_limit > /dev/null; then
        log "✅ Connectivité GitHub disponible"
    else
        log "⚠️  Connectivité GitHub limitée"
    fi

    log "🔗 Interface disponible sur http://localhost:5000"
}

# Affichage des informations de démarrage
show_startup_info() {
    log "🎯 CLAUDE CODE CEO PRÊT"
    echo ""
    echo "📊 Configuration:"
    echo "   👤 User: $GITHUB_USER"
    echo "   📧 Email: $GITHUB_EMAIL"
    echo "   📁 Memory: $(du -sh $MEMORY_DIR | cut -f1)"
    echo "   🔑 Token: $([ -n "$GITHUB_TOKEN" ] && echo "Configuré" || echo "Non configuré")"
    echo ""
    echo "🌐 Interface Web:"
    echo "   URL: http://localhost:5000"
    echo "   API: http://localhost:5000/api/status"
    echo ""
    echo "🚀 Fonctionnalités disponibles:"
    echo "   🔐 Configuration GitHub Token"
    echo "   🧠 Gestion Mémoire Globale CEO"
    echo "   👥 Visualisation Agents"
    echo "   📊 Monitoring Temps Réel"
    echo "   🔄 Synchronisation Automatique"
    echo ""
}

# Fonction de nettoyage
cleanup() {
    log "🛑 Arrêt en cours..."
    exit 0
}

# Capture des signaux
trap cleanup SIGTERM SIGINT

# Exécution principale
main() {
    setup_logging
    check_environment
    setup_github_config
    setup_network
    auto_sync_memory
    show_startup_info

    # Lancer l'application
    log "🚀 Démarrage de l'interface Claude Code CEO..."

    cd "$MEMORY_DIR/ui"

    # Mode debug ou production
    if [ "$DEBUG_MODE" = "true" ]; then
        export FLASK_ENV=development
        export FLASK_DEBUG=1
        log "🐛 Mode DEBUG activé"
    else
        export FLASK_ENV=production
        export FLASK_DEBUG=0
        log "🏭 Mode PRODUCTION activé"
    fi

    # Démarrer l'application
    exec python3 server.py
}

# Point d'entrée
if [ "${1#-}" != "$1" ] || [ "$1" = "server.py" ] || [ "$1" = "python" ]; then
    main
else
    # Permettre d'exécuter d'autres commandes dans le conteneur
    exec "$@"
fi