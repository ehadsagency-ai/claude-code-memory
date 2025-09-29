#!/bin/bash

# Claude Code CEO - Configuration Manager Launcher
# Script de lancement de l'interface professionnelle

set -e

echo "🚀 CLAUDE CODE CEO - CONFIGURATION MANAGER"
echo "=========================================="
echo ""

# Vérifier Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 requis mais non installé"
    echo "💡 Installer avec: brew install python3 (macOS) ou apt-get install python3 (Linux)"
    exit 1
fi

echo "✅ Python 3 détecté"

# Répertoires
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MEMORY_DIR="$(dirname "$SCRIPT_DIR")"
UI_DIR="$SCRIPT_DIR"
SERVER_PY="$UI_DIR/server.py"

echo "📁 Répertoire UI: $UI_DIR"

# Vérifier les dépendances Python
echo "🔍 Vérification des dépendances..."

# Installer les dépendances si nécessaire
REQUIREMENTS=(
    "flask"
    "flask-cors"
    "requests"
)

for package in "${REQUIREMENTS[@]}"; do
    if ! python3 -c "import $package" 2>/dev/null; then
        echo "📦 Installation de $package..."
        pip3 install "$package"
    else
        echo "✅ $package installé"
    fi
done

# Vérifier que le serveur existe
if [ ! -f "$SERVER_PY" ]; then
    echo "❌ Serveur non trouvé: $SERVER_PY"
    exit 1
fi

echo "✅ Serveur trouvé"

# Fonction pour ouvrir le navigateur
open_browser() {
    sleep 3
    echo "🌐 Ouverture du navigateur..."

    if command -v open &> /dev/null; then
        # macOS
        open "http://localhost:5000"
    elif command -v xdg-open &> /dev/null; then
        # Linux
        xdg-open "http://localhost:5000"
    elif command -v start &> /dev/null; then
        # Windows
        start "http://localhost:5000"
    else
        echo "📋 Ouvrir manuellement: http://localhost:5000"
    fi
}

# Fonction de nettoyage
cleanup() {
    echo ""
    echo "🛑 Arrêt du serveur..."
    kill $SERVER_PID 2>/dev/null || true
    exit 0
}

# Capturer les signaux d'arrêt
trap cleanup SIGINT SIGTERM

echo ""
echo "🔥 Démarrage du serveur Configuration Manager..."
echo "📍 URL: http://localhost:5000"
echo "⚠️  Utilisez Ctrl+C pour arrêter"
echo ""

# Démarrer le serveur en arrière-plan
cd "$UI_DIR"
python3 server.py &
SERVER_PID=$!

# Attendre que le serveur démarre
echo "⏳ Initialisation du serveur..."
sleep 2

# Vérifier que le serveur fonctionne
if curl -s "http://localhost:5000/api/status" >/dev/null 2>&1; then
    echo "✅ Serveur démarré avec succès"
    echo ""
    echo "🎯 FONCTIONNALITÉS DISPONIBLES:"
    echo "  🔐 Configuration GitHub Token"
    echo "  🧠 Gestion Mémoire Globale CEO"
    echo "  👥 Visualisation Agents Hiérarchiques"
    echo "  🔄 Synchronisation Automatique"
    echo "  📊 Statistiques en Temps Réel"
    echo ""

    # Ouvrir le navigateur
    open_browser &

    # Attendre que le serveur se termine
    wait $SERVER_PID
else
    echo "❌ Erreur de démarrage du serveur"
    cleanup
    exit 1
fi