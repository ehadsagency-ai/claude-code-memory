# Configuration Personal Access Token GitHub

## 🎯 Objectif
Configurer l'authentification automatique GitHub pour synchroniser votre configuration Claude Code personnelle sur tous vos environnements.

## 📋 Étapes de Configuration

### 1. Créer le Personal Access Token

1. **Aller sur GitHub** : https://github.com/settings/tokens
2. **Cliquer** sur "Generate new token" → "Generate new token (classic)"
3. **Remplir les informations** :
   - **Note** : "Claude Code Memory Sync"
   - **Expiration** : 90 days (ou No expiration pour usage personnel)
   - **Select scopes** :
     - ✅ `repo` (Full control of private repositories)
     - ✅ `workflow` (Update GitHub Action workflows)
     - ✅ `write:packages` (Upload packages)
     - ✅ `delete:packages` (Delete packages)

4. **Cliquer** "Generate token"
5. **COPIER IMMÉDIATEMENT** le token (il ne sera plus visible après)

### 2. Format du Token
```
ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## 🔐 Configuration Sécurisée

### Option A: Variables d'Environnement (Recommandé)
```bash
# Ajouter dans ~/.bashrc ou ~/.zshrc
export GITHUB_TOKEN="ghp_votre_token_ici"
export GITHUB_USER="ehadsagency-ai"
```

### Option B: Fichier de Configuration Sécurisé
```bash
# Créer fichier sécurisé
echo "GITHUB_TOKEN=ghp_votre_token_ici" > ~/.claude/github_credentials
chmod 600 ~/.claude/github_credentials
```

## 🚀 Test de Configuration

### Vérifier l'authentification
```bash
# Test avec curl
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

# Test avec le script CEO
~/.claude/global_memory/sync_scripts/github_sync.sh status
```

## 🔄 Synchronisation Automatique

Une fois configuré, le système CEO :
1. **Sauvegarde automatique** toutes les configurations
2. **Synchronise vers GitHub** après chaque amélioration
3. **Restaure automatiquement** sur nouveaux environnements
4. **Partage entre projets** tous vos patterns optimisés

## 🏗️ Déploiement sur Nouveau Système

```bash
# 1. Cloner votre configuration personnelle
git clone https://github.com/ehadsagency-ai/claude-code-memory.git ~/.claude/global_memory

# 2. Configurer le token
export GITHUB_TOKEN="ghp_votre_token"

# 3. Installer Claude Code avec vos configs
./install_personal_claude_code.sh
```

## 🛡️ Sécurité

- ✅ **Token stocké localement** (pas dans le repository)
- ✅ **Permissions minimales** requises
- ✅ **Expiration configurable**
- ✅ **Révocable à tout moment**

## 📁 Structure après Configuration

```
~/.claude/global_memory/
├── error_patterns/          # Vos erreurs résolues
├── architectures/           # Vos templates de projets
├── optimizations/           # Vos patterns d'optimisation
├── decision_history/        # Vos décisions techniques
└── sync_scripts/           # Scripts de synchronisation

GitHub: ehadsagency-ai/claude-code-memory
├── Toutes vos configurations sauvegardées
├── Patterns de code optimisés
├── Solutions d'erreurs testées
└── Architectures validées
```

## 🎯 Avantages

1. **Configuration unique** → Disponible partout
2. **Apprentissage cumulatif** → Patterns réutilisés
3. **Évolution continue** → Améliorations sauvegardées
4. **Déploiement instantané** → Setup en une commande
5. **Backup automatique** → Jamais de perte de configuration