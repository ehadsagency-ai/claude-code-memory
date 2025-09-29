# CLAUDE CODE - État des Lieux Système
**Date de création**: 2025-09-29
**Dernière mise à jour**: 2025-09-29 22:50
**Version**: 1.0

---

## 🎯 OBJECTIF DE CE DOCUMENT

Ce fichier sert de **mémoire de contexte** pour Claude Code. Il contient:
- ✅ L'architecture complète du système CEO Dashboard
- ✅ Tous les composants et leurs fonctions
- ✅ Les métriques implémentées et leur statut
- ✅ Comment tout fonctionne ensemble
- ✅ Ce qui reste à faire

**Pourquoi?** Pour que je (Claude) puisse reprendre exactement où on s'est arrêté, sans rien oublier.

---

## 📊 SYSTÈME ACTUEL: CEO DASHBOARD + GLOBAL MEMORY

### Architecture Globale

```
┌─────────────────────────────────────────────────────────┐
│                    USER (Browser)                        │
│              http://localhost:3000                       │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│           DASHBOARD (Flask + Alpine.js)                  │
│  - ui/index.html (Frontend)                             │
│  - ui/server.py (Backend API)                           │
│                                                          │
│  Auto-refresh intervals:                                │
│  • Activity log: 2s                                     │
│  • Memory stats: 30s                                    │
│  • GitHub status: 30s                                   │
│  • MCP status: 60s                                      │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              GLOBAL MEMORY (~/.claude/global_memory)     │
│                                                          │
│  ├── activity_logs/                                     │
│  │   └── agent_activity.log (Real-time agent status)   │
│  ├── error_patterns/                                    │
│  │   └── master_error_database.json                    │
│  ├── architectures/                                     │
│  │   ├── project_architectures.json                    │
│  │   └── psl_mines_course_website_2025-09-29.md       │
│  ├── optimizations/                                     │
│  ├── decision_history/                                  │
│  └── ui/ (Dashboard files)                             │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│    AUTO-SAVE SERVICE (Background Process)               │
│  - Runs every 2 minutes                                 │
│  - Auto-commits to Git                                  │
│  - Auto-pushes to GitHub                                │
│  - Log: /tmp/auto_save.log                             │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│    GITHUB REPOSITORY                                     │
│    ehadsagency-ai/claude-code-memory                    │
│    Branch: main                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🚀 COMPOSANTS PRINCIPAUX

### 1. Dashboard (Frontend - index.html)

**Localisation**: `~/.claude/global_memory/ui/index.html`

**Technologies**:
- Alpine.js (Reactive framework)
- Tailwind CSS (Styling)
- Font Awesome (Icons)

**Sections du Dashboard**:

#### A. Configuration GitHub
- Affiche: username, email, token (masqué avec œil pour toggle)
- Status sync temps réel:
  - Badge vert "✅ Synchronisé" si last commit pushed
  - Badge jaune "⏳ En attente" si commits locaux
  - Timestamp: "Last sync: il y a X minutes"
- Boutons: Tester Connexion, Sauvegarder

#### B. Gestion Mémoire Globale
- **Métriques en temps réel**:
  - Erreurs: Nombre de patterns d'erreurs sauvegardés
  - Architectures: Nombre de décisions d'architecture documentées
  - Optimisations: Nombre d'optimisations de code/performance
  - Décisions: Nombre de décisions techniques importantes
- **Animation de chargement**: Spinner + pulse icon
- Boutons: Sync vers GitHub, Pull depuis GitHub, Visualiser

#### C. System Status (Sidebar)
- **Connection Status**: Indicateur vert/rouge
- **Auto-Logging**: Activé (badge bleu)
- **MCP Servers**: Format "X/Y Connectés"
  - Badge vert si tous connectés (2/2)
  - Badge jaune si partiel
  - Servers: ref-tools, filesystem
- **Agents Actifs**: Format "X/17"
  - X = nombre d'agents avec status actif (planning/working/delegating)
  - Pulse vert si X > 0

#### D. Hiérarchie des Agents
**CEO Orchestrator** (Rouge)
- Status badge dynamique
- Description: Strategic + Global Memory

**CTO Technical Lead** (Bleu)
- Status badge dynamique
- Description: DevOps, DevSecOps, Fullstack

**CRO Research Lead** (Vert)
- Status badge dynamique
- Description: Compliance, Legal, RGPD

**Status Badges**:
- 🔵 Bleu (planning/active) - Animation pulse
- 🟡 Jaune (working/delegating) - Spin pour working, pulse pour delegating
- 🟢 Vert (completed/finished) - Pas d'animation
- ⚪ Gris (idle) - Pas d'animation

#### E. Activité des Agents
- Affiche les 50 dernières activités
- Format: `[timestamp] [agent] [status] action`
- Scroll automatique
- Légende des statuts avec code couleur

---

### 2. Backend API (server.py)

**Localisation**: `~/.claude/global_memory/ui/server.py`

**Framework**: Flask (Python 3)

**API Endpoints**:

#### Status & Configuration
```python
GET  /api/status
     → Returns: connection_status, memory_size, agents_active

GET  /api/github/config
     → Returns: username, email, token, repo

GET  /api/github/last_commit
     → Returns: commit_hash, time_ago, message, is_synced, status
     → New in v1.0 (2025-09-29 22:43)
```

#### Memory & Agents
```python
GET  /api/memory/stats
     → Returns: errorPatterns, architectures, optimizations,
                decisions, totalFiles, totalSize

GET  /api/agents
     → Returns: List of agents with name, description, keywords, reports_to

GET  /api/mcp/status
     → Returns: servers[], connected, total, status
     → New in v1.0 (2025-09-29 22:43)
     → Checks: ref-tools, filesystem
```

#### Activity Logging
```python
GET  /api/activity/log
     → Returns: Last 50 activity log entries (reversed)

POST /api/activity/add
     → Body: {agent, status, action}
     → Returns: {success, message}
     → Appends to: activity_logs/agent_activity.log
```

---

### 3. Auto-Save Service

**Localisation**: `~/.claude/global_memory/sync_scripts/auto_save.sh`

**Fonctionnement**:
```bash
while true; do
    # Check for changes
    git status --porcelain

    # If changes detected:
    git add -A
    git commit -m "Auto-save: [timestamp]"
    git push origin main

    # Wait 2 minutes
    sleep 120
done
```

**Configuration**:
- Interval: 2 minutes (120 secondes)
- Log file: `/tmp/auto_save.log`
- Auto-start via: `start_all.sh`
- Stop via: `stop_all.sh` ou `pkill -f auto_save.sh`

**Derniers saves**:
- 22:45:10 - Created SESSION_RESTART_GUIDE.md
- 22:43:09 - Updated dashboard with Priority 2 metrics
- 22:39:08 - Fixed idle status detection

---

## ✅ MÉTRIQUES TEMPS RÉEL IMPLÉMENTÉES

### Priority 1 - CRITIQUE ✅ (Complété 22:31)

1. **Status Badges CEO/CTO/CRO**
   - Fichier: `ui/index.html` lignes 219-268
   - Fonctions JS: `getAgentStatus()`, `getAgentStatusBadge()`, `getAgentStatusIcon()`, `getAgentStatusText()`
   - Parse activity log pour statut en temps réel
   - Bug fix idle à 22:38 (ligne 650 - ajout détection `[idle]`)

2. **Active Agent Counter**
   - Fichier: `ui/index.html` lignes 205-209
   - Fonction: `getActiveAgentCount()`
   - Format: "X/17" avec pulse vert si X > 0
   - Compte agents avec status: planning, active, working, delegating

3. **Auto-Refresh Memory Stats**
   - Interval: 30 secondes
   - Fonction: `loadMemoryStats()`
   - Ligne: 469

4. **Auto-Refresh Activity Log**
   - Interval: 2 secondes
   - Fonction: `loadActivityLog()`
   - Ligne: 466

### Priority 2 - IMPORTANT ✅ (Complété 22:43)

5. **GitHub Last Commit Timestamp**
   - Backend: `/api/github/last_commit` (server.py lignes 387-441)
   - Frontend: `loadGitHubStatus()` (index.html lignes 615-630)
   - Interval: 30 secondes (ligne 472)
   - Affichage: Badge coloré + "Last sync: X ago"
   - Git commands:
     - `git log -1 --format=%H|%ar|%s` (dernier commit)
     - `git log origin/main..HEAD` (vérifier si synced)

6. **MCP Servers Health Check**
   - Backend: `/api/mcp/status` (server.py lignes 443-493)
   - Frontend: `loadMcpStatus()` (index.html lignes 632-644)
   - Interval: 60 secondes (ligne 475)
   - Vérifie: ref-tools, filesystem
   - Affichage: "X/Y Connectés" avec badge vert/jaune

---

## 📁 STRUCTURE DES FICHIERS

```
~/.claude/global_memory/
├── ui/
│   ├── index.html                     # Dashboard frontend (753 lignes)
│   ├── server.py                      # Flask API backend (501 lignes)
│   └── venv/                          # Python virtual environment
│
├── activity_logs/
│   └── agent_activity.log             # Format: [timestamp] [agent] [status] action
│
├── error_patterns/
│   └── master_error_database.json     # Database of error patterns & solutions
│
├── architectures/
│   ├── project_architectures.json     # Structured architecture decisions
│   └── psl_mines_course_website_2025-09-29.md
│
├── optimizations/                     # (Empty for now)
├── decision_history/                  # (Empty for now)
│
├── sync_scripts/
│   ├── auto_save.sh                   # Auto-save daemon (2 min interval)
│   └── github_sync.sh                 # Manual sync script
│
├── docker/                            # Docker configurations
├── install_scripts/                   # Installation scripts
│
├── start_all.sh                       # Start dashboard + auto-save
├── stop_all.sh                        # Stop all services
│
├── CLAUDE_CODE.md                     # ← Ce fichier (état des lieux)
├── SESSION_RESTART_GUIDE.md           # Guide utilisateur redémarrage
├── REAL_TIME_METRICS_GAPS.md          # Analyse des métriques (historique)
├── EFFICIENCY_AUDIT_2025-09-29.md     # Audit d'efficacité système
├── MCP_CONTEXT7_CONFIGURATION.md      # Config MCP servers
├── DEPLOYMENT_GUIDE.md                # Guide de déploiement
├── README.md                          # Documentation générale
└── memory_config.json                 # Configuration mémoire

Logs système (temp):
/tmp/dashboard.log                     # Flask server logs
/tmp/auto_save.log                     # Auto-save activity logs
```

---

## 🔄 WORKFLOWS IMPORTANTS

### Workflow 1: Démarrage Session

```bash
# 1. Lancer tous les services
~/.claude/global_memory/start_all.sh

# 2. Vérifier services actifs
lsof -ti:3000           # Dashboard running?
pgrep -f auto_save.sh   # Auto-save running?

# 3. Accéder au dashboard
# Ouvrir: http://localhost:3000
# Hard refresh: Cmd+Shift+R (important pour cache)

# 4. Mettre agents en idle si pas de tâches
curl -X POST http://localhost:3000/api/activity/add \
  -H "Content-Type: application/json" \
  -d '{"agent": "CEO-Orchestrator", "status": "idle", "action": "Waiting for tasks"}'
```

### Workflow 2: Logger une Activité

```bash
# Format standard
curl -X POST http://localhost:3000/api/activity/add \
  -H "Content-Type: application/json" \
  -d '{
    "agent": "CEO-Orchestrator",      # Nom de l'agent
    "status": "working",               # idle, planning, active, working, delegating, completed
    "action": "Description de l'action"
  }'

# Exemples:
# CEO commence une tâche
curl ... -d '{"agent": "CEO-Orchestrator", "status": "planning", "action": "Analyzing user request"}'

# CTO travaille
curl ... -d '{"agent": "CTO-Technical-Lead", "status": "working", "action": "Implementing feature X"}'

# CRO délègue
curl ... -d '{"agent": "CRO-Research-Lead", "status": "delegating", "action": "Assigning to documentation-researcher"}'

# Tâche terminée
curl ... -d '{"agent": "System", "status": "completed", "action": "✅ Task completed successfully"}'
```

### Workflow 3: Vérifier GitHub Sync

```bash
# Voir derniers saves
tail -20 /tmp/auto_save.log

# Vérifier via API
curl http://localhost:3000/api/github/last_commit

# Output attendu:
{
  "success": true,
  "commit_hash": "e4f0b8f",
  "time_ago": "il y a 5 minutes",
  "message": "Auto-save: 2025-09-29 22:45:10",
  "is_synced": true,
  "status": "synced"
}
```

---

## 🎨 STATUTS AGENTS & COULEURS

### Statuts Disponibles

| Status      | Badge Color | Animation | Usage                           |
|-------------|-------------|-----------|----------------------------------|
| `idle`      | Gris        | Aucune    | Agent en attente                |
| `planning`  | Bleu        | Pulse     | Planification/analyse           |
| `active`    | Bleu        | Pulse     | Actif/en cours                  |
| `working`   | Jaune       | Spin      | Travail/implémentation          |
| `delegating`| Jaune       | Pulse     | Délégation à sous-agents        |
| `completed` | Vert        | Aucune    | Tâche terminée                  |
| `finished`  | Vert        | Aucune    | Terminé (alias de completed)    |

### Agents Configurés (17 total)

**Executives (3)**:
- CEO-Orchestrator (Strategic + Memory)
- CTO-Technical-Lead (DevOps, DevSecOps, Fullstack)
- CRO-Research-Lead (Compliance, Legal, RGPD)

**Technical Specialists (9)**:
- Data-Science-Optimizer
- Jupyter-Notebook-Assistant
- Docker-Environment-Manager
- Error-Debugger
- DevOps-Specialist
- DevSecOps-Specialist
- Fullstack-Developer
- Code-Reviewer
- MCP-Integration

**Research Specialists (5)**:
- Documentation-Researcher
- Compliance-Specialist
- Legal-Advisor
- RGPD-Specialist
- Security-Auditor

---

## 🐛 BUGS RÉSOLUS

### Bug #1: Statuts ne changeaient pas (22:34)
**Problème**: CEO/CTO/CRO affichaient toujours planning/working/delegating même en idle
**Cause**: Fonction `getAgentStatus()` ne détectait pas `[idle]` dans les logs
**Fix**: Ajout de `if (activity.includes('[idle]')) return 'idle';` ligne 650
**Commit**: d2a422e

### Bug #2: Cache navigateur (22:38)
**Problème**: Dashboard n'affichait pas les mises à jour
**Solution**: Hard refresh `Cmd+Shift+R`
**Note**: Ajouté dans troubleshooting guide

---

## 🔧 CONFIGURATIONS IMPORTANTES

### Flask Server
```python
Host: localhost
Port: 3000
Debug: False
CORS: Disabled (localhost only)
```

### Git/GitHub
```bash
Repository: https://github.com/ehadsagency-ai/claude-code-memory.git
Branch: main
User: ehadsagency-ai
Email: ehads.agency@gmail.com
Token: (stored in sync_scripts/credentials.sh, mode 600)
```

### MCP Servers
```
ref-tools: Documentation search (Context7 API)
filesystem: File operations
```

### Auto-Refresh Intervals
```
Activity log: 2 seconds
Memory stats: 30 seconds
GitHub status: 30 seconds
MCP status: 60 seconds
Auto-save: 120 seconds (2 minutes)
```

---

## 📋 CE QUI RESTE À FAIRE (Priority 3)

### Nice to Have (Non critique):

1. **Animation nouveaux logs**
   - Highlight en jaune les nouvelles entrées pendant 2s
   - Smooth scroll vers le haut quand nouveau log

2. **Notifications toast**
   - Toast notification pour événements importants
   - Exemples: "New commit synced", "Agent completed task"

3. **Graphiques de tendance**
   - Commits par jour (7 derniers jours)
   - Agents actifs au fil du temps (timeline)
   - Erreurs résolues par semaine

4. **Bouton Visualiser fonctionnel**
   - Modal ou nouvelle page
   - Arborescence interactive de la mémoire
   - Possibilité de rechercher/filtrer

5. **Export logs**
   - Export activity log en JSON/CSV
   - Filtrage par agent, date, status

6. **GitHub commit history**
   - Afficher les 10 derniers commits
   - Lien vers GitHub pour chaque commit

---

## ⚠️ POINTS D'ATTENTION

### Pour Claude (moi):

1. **TOUJOURS logger mes activités** quand je travaille sur une tâche complexe
   ```bash
   # Début de tâche
   curl POST /api/activity/add {"agent": "CEO-Orchestrator", "status": "planning", ...}

   # Pendant
   curl POST /api/activity/add {"agent": "CTO-Technical-Lead", "status": "working", ...}

   # Fin
   curl POST /api/activity/add {"agent": "System", "status": "completed", ...}
   ```

2. **Mettre agents en idle** quand pas de tâches actives

3. **Vérifier auto-save** fonctionne:
   ```bash
   tail -5 /tmp/auto_save.log
   # Devrait voir save toutes les 2 min si changements
   ```

4. **Hard refresh dashboard** après modifications du code frontend

5. **Redémarrer Flask** après modifications du code backend:
   ```bash
   pkill -f "python.*server.py"
   cd ~/.claude/global_memory/ui && source venv/bin/activate
   nohup python server.py > /tmp/dashboard.log 2>&1 &
   ```

### Pour l'utilisateur:

1. **Toujours utiliser `start_all.sh`** au démarrage de session
2. **Hard refresh navigateur** si données semblent anciennes
3. **Vérifier logs** si problème:
   - Dashboard: `/tmp/dashboard.log`
   - Auto-save: `/tmp/auto_save.log`
4. **Ne jamais modifier** `activity_logs/agent_activity.log` manuellement

---

## 📚 DOCUMENTS DE RÉFÉRENCE

### Pour comprendre le système:
1. **CLAUDE_CODE.md** (ce fichier) - Vue d'ensemble technique complète
2. **SESSION_RESTART_GUIDE.md** - Guide utilisateur pour démarrer/arrêter
3. **REAL_TIME_METRICS_GAPS.md** - Historique des métriques implémentées

### Pour développement:
4. **EFFICIENCY_AUDIT_2025-09-29.md** - Audit initial du système
5. **MCP_CONTEXT7_CONFIGURATION.md** - Configuration MCP servers
6. **DEPLOYMENT_GUIDE.md** - Déploiement et installation

### Fichiers de config:
7. **memory_config.json** - Configuration mémoire globale
8. **.claude/agents.json** - Configuration des 17 agents
9. **.claude/settings.local.json** - Settings Claude Code

---

## ✅ CHECKLIST DÉMARRAGE NOUVELLE SESSION

```bash
# 1. Services
□ Lancer: ~/.claude/global_memory/start_all.sh
□ Vérifier dashboard: lsof -ti:3000
□ Vérifier auto-save: pgrep -f auto_save.sh

# 2. Dashboard
□ Ouvrir: http://localhost:3000
□ Hard refresh: Cmd+Shift+R
□ Vérifier métriques chargent (pas de 0)

# 3. Status
□ GitHub sync affiche timestamp
□ MCP servers affiche 2/2
□ Agents affichent "Idle" si pas de tâches
□ Activity log affiche dernières entrées

# 4. Tests
□ Logger test activity pour vérifier badges changent
□ Attendre 30s pour vérifier auto-refresh stats
□ Vérifier auto-save log montre activité
```

---

## 🎯 RÉSUMÉ RAPIDE

**Qu'est-ce que c'est?**
Un dashboard temps réel qui montre ce que je (Claude) fais, avec auto-save vers GitHub.

**Comment ça marche?**
- Frontend Alpine.js appelle API Flask
- API lit logs et fichiers de mémoire
- Auto-save daemon commit/push toutes les 2 min
- Tout est sauvegardé sur GitHub

**Qu'est-ce qui est temps réel?**
✅ Status agents (badges colorés)
✅ Active agent counter
✅ Memory stats
✅ Activity log
✅ GitHub sync status
✅ MCP server status

**Comment l'utiliser?**
```bash
~/.claude/global_memory/start_all.sh
# Puis ouvrir http://localhost:3000
```

**Où trouver les logs?**
- Dashboard: `/tmp/dashboard.log`
- Auto-save: `/tmp/auto_save.log`
- Activity: `~/.claude/global_memory/activity_logs/agent_activity.log`

---

**Version**: 1.0
**Dernière mise à jour**: 2025-09-29 22:50
**Status**: ✅ Système opérationnel - Priority 1 & 2 complétés
**Prochaine mise à jour**: Quand Priority 3 sera implémentée