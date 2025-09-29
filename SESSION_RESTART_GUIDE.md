# Guide de Redémarrage - Claude Code CEO Dashboard

## 🚀 Démarrage Rapide

### Démarrer tous les services
```bash
~/.claude/global_memory/start_all.sh
```

Ce script lance automatiquement:
- ✅ Dashboard Flask (http://localhost:3000)
- ✅ Auto-save service (toutes les 2 minutes)

### Arrêter tous les services
```bash
~/.claude/global_memory/stop_all.sh
```

---

## 📊 Vérifier l'état du système

### 1. Vérifier si les services tournent
```bash
# Dashboard
lsof -ti:3000

# Auto-save
pgrep -f "auto_save.sh"
```

### 2. Accéder au dashboard
```
http://localhost:3000
```

### 3. Voir les logs en temps réel
```bash
# Dashboard logs
tail -f /tmp/dashboard.log

# Auto-save logs
tail -f /tmp/auto_save.log
```

---

## 🔧 Métriques Temps Réel Disponibles

### ✅ Priority 1 - COMPLÉTÉ (2025-09-29 22:43)
1. **Status badges CEO/CTO/CRO** - Badges colorés avec animations
   - Bleu (planning/active) avec pulse
   - Jaune (working/delegating) avec spin/pulse
   - Vert (completed) sans animation
   - Gris (idle) sans animation

2. **Active agent counter** - Format X/17 avec pulse vert si actifs

3. **Auto-refresh stats mémoire** - Toutes les 30 secondes

4. **Activity log refresh** - Toutes les 2 secondes

### ✅ Priority 2 - COMPLÉTÉ (2025-09-29 22:43)
5. **GitHub last commit timestamp**
   - Badge vert "✅ Synchronisé" si synced
   - Badge jaune "⏳ En attente" si pending
   - Affiche "Last sync: X minutes ago"
   - Refresh toutes les 30 secondes

6. **MCP Servers health check**
   - Badge vert si tous connectés (X/X)
   - Badge jaune si partiel (X/Y)
   - Liste: ref-tools, filesystem
   - Refresh toutes les 60 secondes

---

## 📝 Logger une activité manuellement

### Depuis Claude Code (curl)
```bash
curl -X POST http://localhost:3000/api/activity/add \
  -H "Content-Type: application/json" \
  -d '{"agent": "CEO-Orchestrator", "status": "planning", "action": "Analyzing user request"}'
```

### Statuts disponibles:
- `idle` - Agent en attente (gris)
- `planning` - Planification en cours (bleu, pulse)
- `active` - Actif (bleu, pulse)
- `working` - Travail en cours (jaune, spin)
- `delegating` - Délégation (jaune, pulse)
- `completed` - Terminé (vert)
- `finished` - Fini (vert)

### Agents nommés dans le système:
- `CEO-Orchestrator`
- `CTO-Technical-Lead`
- `CRO-Research-Lead`
- `System` (pour logs système)

---

## 🔄 Auto-Save

### Configuration actuelle:
- **Fréquence**: Toutes les 2 minutes
- **Repository**: `https://github.com/ehadsagency-ai/claude-code-memory.git`
- **Branch**: `main`
- **Log**: `/tmp/auto_save.log`

### Vérifier le dernier save:
```bash
tail -10 /tmp/auto_save.log
```

### Forcer un save manuel:
```bash
cd ~/.claude/global_memory
git add -A
git commit -m "Manual save: $(date)"
git push origin main
```

---

## ⚠️ Troubleshooting

### Dashboard ne démarre pas
```bash
# Vérifier si le port 3000 est occupé
lsof -ti:3000

# Tuer le processus si nécessaire
kill $(lsof -ti:3000)

# Redémarrer
~/.claude/global_memory/start_all.sh
```

### Auto-save ne fonctionne pas
```bash
# Vérifier si le script tourne
pgrep -f "auto_save.sh"

# Vérifier les logs
cat /tmp/auto_save.log

# Relancer manuellement
~/.claude/global_memory/sync_scripts/auto_save.sh &
```

### Dashboard affiche des données anciennes
1. **Hard refresh**: `Cmd+Shift+R` (Mac) ou `Ctrl+Shift+R` (Windows/Linux)
2. **Vider le cache**: Outils développeur (F12) → Network → Cocher "Disable cache"
3. **Redémarrer le navigateur**: Fermer complètement et rouvrir

### Agents n'affichent pas idle
```bash
# Mettre manuellement les agents en idle
curl -X POST http://localhost:3000/api/activity/add \
  -H "Content-Type: application/json" \
  -d '{"agent": "CEO-Orchestrator", "status": "idle", "action": "Waiting for tasks"}'

curl -X POST http://localhost:3000/api/activity/add \
  -H "Content-Type: application/json" \
  -d '{"agent": "CTO-Technical-Lead", "status": "idle", "action": "Waiting for tasks"}'

curl -X POST http://localhost:3000/api/activity/add \
  -H "Content-Type: application/json" \
  -d '{"agent": "CRO-Research-Lead", "status": "idle", "action": "Waiting for tasks"}'
```

---

## 📚 API Endpoints Disponibles

### Status et Configuration
- `GET /api/status` - Status général du système
- `GET /api/github/config` - Configuration GitHub
- `GET /api/github/last_commit` - Dernier commit et timestamp

### Mémoire et Agents
- `GET /api/memory/stats` - Statistiques mémoire
- `GET /api/agents` - Liste des agents configurés
- `GET /api/mcp/status` - Status des serveurs MCP

### Activity Logging
- `GET /api/activity/log` - Dernières 50 activités
- `POST /api/activity/add` - Ajouter une activité

---

## 🎯 Prochaines Améliorations (Priority 3)

### Nice to Have:
1. Animation pour nouveaux logs dans activity feed
2. Notifications toast pour événements importants
3. Graphiques de tendance (commits par jour, agents actifs au fil du temps)
4. Historique des erreurs avec possibilité de filtrer
5. Export des logs en JSON/CSV

---

## 📁 Structure des Fichiers

```
~/.claude/global_memory/
├── ui/
│   ├── index.html           # Dashboard frontend
│   ├── server.py            # Flask backend
│   └── venv/                # Python virtual environment
├── sync_scripts/
│   ├── auto_save.sh         # Auto-save daemon
│   └── github_sync.sh       # Sync script manuel
├── activity_logs/
│   └── agent_activity.log   # Logs d'activité
├── start_all.sh             # Démarrage tous services
├── stop_all.sh              # Arrêt tous services
└── SESSION_RESTART_GUIDE.md # Ce fichier

Logs système:
/tmp/dashboard.log           # Logs Flask
/tmp/auto_save.log          # Logs auto-save
```

---

## ✅ Checklist Démarrage Session

- [ ] Lancer `~/.claude/global_memory/start_all.sh`
- [ ] Vérifier dashboard accessible: http://localhost:3000
- [ ] Vérifier auto-save tourne: `pgrep -f auto_save`
- [ ] Hard refresh navigateur: `Cmd+Shift+R`
- [ ] Vérifier agents affichent "Idle" si pas de tâches
- [ ] Vérifier GitHub sync affiche "Last sync: X ago"
- [ ] Vérifier MCP servers affiche "2/2 Connectés"

---

**Dernière mise à jour**: 2025-09-29 22:43
**Version**: 1.0
**Status**: ✅ Tous les métriques temps réel implémentés