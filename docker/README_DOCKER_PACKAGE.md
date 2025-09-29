# Claude Code CEO System - Docker Package
**Version:** 2.0
**Date:** 2025-09-29

## 🎯 Qu'est-ce que c'est?

Un **package Docker complet** qui inclut Claude Code avec **toute la configuration pré-installée**:

✅ **Dashboard temps réel** - Monitoring des agents
✅ **Auto-save GitHub** - Sauvegarde automatique toutes les 2 minutes
✅ **13 Agents configurés** - CEO → CTO/CRO → Specialists
✅ **MCP Servers** - ref-tools, filesystem
✅ **Documentation complète** - Guides + rapports

**En un seul clic, tout est prêt!** 🚀

---

## 📦 Installation

### Prérequis

- Docker Desktop installé: https://docs.docker.com/get-docker/
- docker-compose installé
- 2 GB de RAM disponible
- 500 MB d'espace disque

### Installation Automatique (Recommandé)

```bash
# Télécharger et exécuter
curl -fsSL https://raw.githubusercontent.com/ehadsagency-ai/claude-code-memory/main/docker/ONE_CLICK_INSTALL.sh | bash
```

ou

```bash
# Cloner le repository
git clone https://github.com/ehadsagency-ai/claude-code-memory.git
cd claude-code-memory/docker

# Exécuter l'installation
./ONE_CLICK_INSTALL.sh
```

### Installation Manuelle

```bash
# 1. Cloner
git clone https://github.com/ehadsagency-ai/claude-code-memory.git
cd claude-code-memory/docker

# 2. Créer fichier .env (optionnel pour GitHub sync)
cat > .env << EOF
GITHUB_USER=votre-username
GITHUB_EMAIL=votre@email.com
GITHUB_TOKEN=votre_token_github
GITHUB_REPO=claude-code-memory
AUTO_SAVE_ENABLED=true
AUTO_SAVE_INTERVAL=120
EOF

# 3. Build et start
docker-compose -f docker-compose.complete.yml up -d
```

---

## 🚀 Utilisation

### Accès

Une fois le container lancé:

- **Dashboard:** http://localhost:3000
- **API:** http://localhost:3000/api/*

### Première Utilisation

1. Ouvrir http://localhost:3000 dans votre navigateur
2. Le dashboard affiche:
   - Status des agents (CEO/CTO/CRO avec badges colorés)
   - Activity log en temps réel
   - Métriques mémoire
   - GitHub sync status
   - MCP servers status
3. Tous les agents sont en statut "Idle" (gris) en attente de tâches

### Dashboard Features

**Métriques temps réel:**
- ✅ Status badges agents (Idle/Planning/Working/Completed)
- ✅ Active agent counter (X/17)
- ✅ GitHub last commit ("Last sync: X ago")
- ✅ MCP servers (2/2 Connectés)
- ✅ Activity log (refresh 2s)
- ✅ Memory stats (refresh 30s)

**Légende des couleurs:**
- 🔵 Bleu (planning/active) - Animation pulse
- 🟡 Jaune (working/delegating) - Spin/pulse
- 🟢 Vert (completed) - Statique
- ⚪ Gris (idle) - Statique

---

## 🔧 Commandes Docker

### Gérer le container

```bash
# Voir les logs
docker-compose -f docker-compose.complete.yml logs -f

# Arrêter
docker-compose -f docker-compose.complete.yml down

# Redémarrer
docker-compose -f docker-compose.complete.yml restart

# Entrer dans le container
docker exec -it claude-code-ceo-system bash

# Voir le statut
docker-compose -f docker-compose.complete.yml ps
```

### Inside Container

Une fois dans le container:

```bash
# Voir logs dashboard
tail -f /tmp/dashboard.log

# Voir logs auto-save
tail -f /tmp/auto_save.log

# Voir activity log
tail -f /root/.claude/global_memory/activity_logs/agent_activity.log

# Accéder à la configuration
cd /root/.claude/global_memory
ls -la

# Lire la documentation
cat CLAUDE_CODE.md
cat SESSION_RESTART_GUIDE.md
```

---

## 📚 Configuration

### Structure Inside Container

```
/root/.claude/
├── settings.json                    # 13 agents configurés
└── global_memory/
    ├── CLAUDE_CODE.md              # État des lieux technique
    ├── SESSION_RESTART_GUIDE.md    # Guide utilisateur
    ├── VERIFICATION_REPORT_2025-09-29.md
    ├── ui/
    │   ├── index.html              # Dashboard (747 lignes)
    │   └── server.py               # API Flask (500 lignes)
    ├── sync_scripts/
    │   └── auto_save.sh            # Auto-save daemon
    ├── activity_logs/
    │   └── agent_activity.log      # Real-time activity
    ├── architectures/
    ├── error_patterns/
    └── ...
```

### Configuration GitHub Auto-Save (Optionnel)

Pour activer la sauvegarde automatique vers GitHub:

1. **Créer un GitHub Personal Access Token**
   - Aller sur: https://github.com/settings/tokens
   - Generate new token (classic)
   - Permissions: `repo`, `workflow`, `write:packages`

2. **Configurer dans .env**
```bash
GITHUB_USER=votre-username
GITHUB_EMAIL=votre@email.com
GITHUB_TOKEN=ghp_votre_token_ici
GITHUB_REPO=claude-code-memory
```

3. **Redémarrer le container**
```bash
docker-compose -f docker-compose.complete.yml restart
```

L'auto-save commit et push automatiquement toutes les 2 minutes!

---

## 🎯 Agents Configurés

### Hiérarchie

```
CEO Orchestrator (Strategic + Memory)
├── CTO Technical Lead
│   ├── DevOps Specialist
│   ├── DevSecOps Specialist
│   ├── Fullstack Developer
│   ├── Error Debugger
│   └── Code Reviewer
└── CRO Research Lead
    ├── Documentation Researcher
    ├── MCP Integration Specialist
    ├── Compliance Specialist
    ├── Legal Advisor
    └── RGPD Specialist
```

### Status des Agents

Les agents peuvent avoir ces statuts:
- **idle**: En attente (badge gris)
- **planning**: Planification (badge bleu, pulse)
- **active**: Actif (badge bleu, pulse)
- **working**: Travail en cours (badge jaune, spin)
- **delegating**: Délégation (badge jaune, pulse)
- **completed**: Terminé (badge vert)

---

## 📊 API Endpoints

### Status & Configuration
- `GET /api/status` - Status général
- `GET /api/github/config` - Configuration GitHub
- `GET /api/github/last_commit` - Dernier commit + timestamp

### Memory & Agents
- `GET /api/memory/stats` - Statistiques mémoire
- `GET /api/agents` - Liste des 17 agents
- `GET /api/mcp/status` - Status serveurs MCP

### Activity Logging
- `GET /api/activity/log` - Dernières 50 activités
- `POST /api/activity/add` - Logger une activité

**Exemple d'usage:**
```bash
# Logger une activité
curl -X POST http://localhost:3000/api/activity/add \
  -H "Content-Type: application/json" \
  -d '{
    "agent": "CEO-Orchestrator",
    "status": "planning",
    "action": "Analyzing user request"
  }'
```

---

## 🐛 Troubleshooting

### Container ne démarre pas

```bash
# Vérifier les logs
docker-compose -f docker-compose.complete.yml logs

# Vérifier si port 3000 est libre
lsof -ti:3000

# Rebuild from scratch
docker-compose -f docker-compose.complete.yml down -v
docker-compose -f docker-compose.complete.yml build --no-cache
docker-compose -f docker-compose.complete.yml up -d
```

### Dashboard affiche données anciennes

1. Hard refresh dans le navigateur: `Cmd+Shift+R` (Mac) ou `Ctrl+Shift+R` (Windows)
2. Désactiver cache: DevTools (F12) → Network → Disable cache

### Auto-save ne fonctionne pas

```bash
# Vérifier si configuré
docker exec claude-code-ceo-system cat /root/.claude/global_memory/sync_scripts/credentials.sh

# Voir les logs auto-save
docker exec claude-code-ceo-system tail -f /tmp/auto_save.log

# Vérifier processus
docker exec claude-code-ceo-system pgrep -f auto_save.sh
```

---

## 🔄 Mise à Jour

### Mettre à jour vers la dernière version

```bash
cd claude-code-memory/docker

# Pull latest
git pull origin main

# Rebuild
docker-compose -f docker-compose.complete.yml down
docker-compose -f docker-compose.complete.yml build --no-cache
docker-compose -f docker-compose.complete.yml up -d
```

### Sauvegarder vos données

Les données sont persistées dans un volume Docker:

```bash
# Backup
docker run --rm -v claude_memory:/data -v $(pwd):/backup ubuntu tar czf /backup/claude_backup.tar.gz /data

# Restore
docker run --rm -v claude_memory:/data -v $(pwd):/backup ubuntu bash -c "cd /data && tar xzf /backup/claude_backup.tar.gz --strip 1"
```

---

## 📝 Notes Importantes

### ❌ JAMAIS de Mock/Demo/Simulation

Ce package contient **UNIQUEMENT du code réel et fonctionnel**:
- ✅ Dashboard appelle de vraies API
- ✅ API lit de vrais fichiers
- ✅ Auto-save fait de vrais commits Git
- ✅ Configuration agents est réelle
- ❌ Aucune donnée hardcodée ou simulée

### Limitation Actuelle: Task Tool

La configuration multi-agent est **complète et prête**, MAIS:
- ⚠️ L'outil `Task` n'est pas encore disponible dans Claude Code 2.0.0
- ✅ Configuration sauvegardée dans `/root/.claude/settings.json`
- ✅ 13 agents définis avec system prompts complets
- 🔜 Sera activé automatiquement quand Task tool sera disponible

En attendant, le dashboard fonctionne parfaitement pour:
- ✅ Monitoring en temps réel
- ✅ Activity logging
- ✅ GitHub sync
- ✅ Métriques mémoire

---

## 🌍 Distribution

### URLs Publiques

- **Repository:** https://github.com/ehadsagency-ai/claude-code-memory
- **Docker Hub:** (À venir) `docker pull ehadsagency-ai/claude-code-ceo:2.0`

### Partager

Partagez simplement le lien:
```
https://github.com/ehadsagency-ai/claude-code-memory
```

Ou le script d'installation direct:
```
curl -fsSL https://raw.githubusercontent.com/ehadsagency-ai/claude-code-memory/main/docker/ONE_CLICK_INSTALL.sh | bash
```

---

## 📧 Support

- **Issues:** https://github.com/ehadsagency-ai/claude-code-memory/issues
- **Documentation:** Voir `CLAUDE_CODE.md` dans le container
- **Guide utilisateur:** Voir `SESSION_RESTART_GUIDE.md`

---

## 📜 License

MIT License - See LICENSE file

---

## ✅ Checklist Installation

- [ ] Docker Desktop installé et démarré
- [ ] Repository cloné
- [ ] Script `ONE_CLICK_INSTALL.sh` exécuté
- [ ] Container running (vérifier avec `docker ps`)
- [ ] Dashboard accessible (http://localhost:3000)
- [ ] Hard refresh navigateur effectué
- [ ] Agents affichent statut "Idle"
- [ ] (Optionnel) GitHub token configuré pour auto-save

---

**Version:** 2.0
**Date:** 2025-09-29
**Status:** ✅ Production Ready
**Maintainer:** ehadsagency-ai