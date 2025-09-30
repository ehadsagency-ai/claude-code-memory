# 🤖 Guide d'Auto-Activation des Agents Claude Code

**Date** : 2025-09-30
**Version** : 1.0
**Statut** : ✅ OPÉRATIONNEL

---

## 🎯 Objectif

Permettre à Claude de **spawner automatiquement les agents** appropriés selon la complexité et le type de tâche demandée par l'utilisateur.

---

## 📊 Système de Détection

### Détection Automatique de la Complexité

**Niveau 1 : Tâche Simple** (Pas d'agents)
- Questions simples
- Lecture de fichier unique
- Commandes bash simples
- Réponses directes

**Niveau 2 : Tâche Technique** (Spawn CTO)
- Code, debug, déploiement
- Infrastructure, Docker, Kubernetes
- CI/CD, automation
- Revue de code

**Niveau 3 : Tâche Recherche** (Spawn CRO)
- Documentation technique
- Compliance, légal, RGPD
- Recherche d'information
- Intégration MCP/API

**Niveau 4 : Tâche Complexe** (Spawn CEO → délégation)
- Multi-étapes
- Architecture système
- Projets complets
- Coordination de plusieurs domaines

---

## 🔑 Mots-Clés d'Activation

### Trigger CTO (Technique)

```
Technical Keywords:
- code, debug, deploy, deployment
- docker, kubernetes, container
- ci/cd, pipeline, jenkins
- git, github, version control
- infrastructure, terraform, ansible
- monitoring, prometheus, grafana
- security, vulnerability, devsecops
- test, testing, pytest, unittest
- api, backend, frontend, fullstack
- database, sql, nosql
- performance, optimization, profiling
```

**Action** : `spawn('cto-technical-lead')` ou directement un spécialiste

---

### Trigger CRO (Recherche/Compliance)

```
Research Keywords:
- documentation, docs, recherche
- compliance, rgpd, gdpr, legal
- contract, license, intellectual property
- mcp, integration, external api
- security audit, vulnerability assessment
- iso, soc2, regulatory
- privacy, data protection
- standards, best practices
```

**Action** : `spawn('cro-research-lead')` ou directement un spécialiste

---

### Trigger CEO (Complexe/Multi-domaines)

```
Complex Keywords:
- architecture, system design
- multi-step, complex, workflow
- orchestration, coordination
- strategy, planning, roadmap
- startup, business, commercial
- full projet, end-to-end
- automation complète
```

**Action** : `spawn('ceo-orchestrator')` → CEO délègue ensuite

---

## 🚀 Workflow d'Auto-Activation

### Étape 1 : Analyse de la Requête

```python
def analyze_user_request(request: str) -> dict:
    """
    Analyse la requête utilisateur et détermine:
    - Niveau de complexité
    - Type de tâche
    - Agent(s) approprié(s)
    """

    request_lower = request.lower()

    # Détection keywords
    has_technical = any(kw in request_lower for kw in TECHNICAL_KEYWORDS)
    has_research = any(kw in request_lower for kw in RESEARCH_KEYWORDS)
    has_complex = any(kw in request_lower for kw in COMPLEX_KEYWORDS)

    # Comptage des mots (indicateur de complexité)
    word_count = len(request.split())

    # Détection multi-étapes
    has_multiple_steps = any(word in request_lower for word in ['et', 'puis', 'ensuite', 'après'])

    return {
        'complexity_level': determine_complexity(word_count, has_multiple_steps, has_complex),
        'domain': 'technical' if has_technical else 'research' if has_research else 'general',
        'should_spawn_agent': has_technical or has_research or has_complex,
        'recommended_agent': determine_agent(has_technical, has_research, has_complex)
    }
```

---

### Étape 2 : Décision de Spawn

```python
def should_activate_agents(analysis: dict) -> bool:
    """Décide si les agents doivent être activés"""

    # Critères d'activation
    if analysis['complexity_level'] >= 3:  # Complexe ou très complexe
        return True

    if analysis['should_spawn_agent']:
        return True

    if analysis['domain'] in ['technical', 'research']:
        return True

    return False
```

---

### Étape 3 : Sélection de l'Agent

```python
def determine_agent(has_technical: bool, has_research: bool, has_complex: bool) -> str:
    """Détermine quel agent principal spawner"""

    # Si complexe ET multi-domaines → CEO
    if has_complex or (has_technical and has_research):
        return 'ceo-orchestrator'

    # Si technique pur → CTO
    if has_technical:
        return 'cto-technical-lead'

    # Si recherche/compliance pur → CRO
    if has_research:
        return 'cro-research-lead'

    # Par défaut, pas d'agent (Claude répond directement)
    return None
```

---

### Étape 4 : Exécution

```python
def execute_with_agents(user_request: str):
    """Exécute la requête avec ou sans agents"""

    # Analyser la requête
    analysis = analyze_user_request(user_request)

    # Logger l'analyse
    log_activity('SYSTEM', 'analyzing', f"Request analysis: {analysis}")

    # Décider si spawn nécessaire
    if should_activate_agents(analysis):
        agent = analysis['recommended_agent']

        # Logger le spawn
        log_activity('SYSTEM', 'spawning', f"Spawning agent: {agent}")

        # Spawner l'agent via Task tool
        result = spawn_agent(agent, user_request)

        # Logger la complétion
        log_activity(agent, 'completed', f"Task completed")

        return result

    else:
        # Répondre directement sans agents
        log_activity('Claude', 'responding', "Direct response (no agents)")
        return respond_directly(user_request)
```

---

## 🧪 Exemples Concrets

### Exemple 1 : Tâche Simple (Pas d'agent)

**User** : "Quel est le contenu du fichier README.md ?"

**Analyse** :
- Complexity: 1 (simple)
- Domain: general
- Should spawn: ❌ NO

**Action** : Claude répond directement avec `Read` tool

---

### Exemple 2 : Tâche Technique (Spawn CTO)

**User** : "Crée un Dockerfile pour déployer une application Flask avec Redis"

**Analyse** :
- Complexity: 2 (technique)
- Domain: technical
- Keywords: docker, deploy, application
- Should spawn: ✅ YES
- Agent: `cto-technical-lead`

**Action** :
```python
spawn('cto-technical-lead', {
    'task': 'Create Dockerfile for Flask + Redis',
    'context': 'DevOps deployment task'
})
```

**CTO délègue** : `devops-specialist` pour l'infrastructure

---

### Exemple 3 : Tâche Recherche (Spawn CRO)

**User** : "Recherche la documentation officielle de Kubernetes sur les Persistent Volumes"

**Analyse** :
- Complexity: 2 (recherche)
- Domain: research
- Keywords: documentation, recherche
- Should spawn: ✅ YES
- Agent: `cro-research-lead`

**Action** :
```python
spawn('cro-research-lead', {
    'task': 'Find Kubernetes PV documentation',
    'mcp_tools': ['ref-tools']
})
```

**CRO délègue** : `documentation-researcher` + `mcp-integration`

---

### Exemple 4 : Tâche Complexe (Spawn CEO)

**User** : "Crée un système complet de CI/CD avec tests automatisés, déploiement Docker et monitoring Prometheus"

**Analyse** :
- Complexity: 4 (très complexe)
- Domain: multi (technical + architecture)
- Keywords: système complet, ci/cd, docker, monitoring
- Should spawn: ✅ YES
- Agent: `ceo-orchestrator`

**Action** :
```python
spawn('ceo-orchestrator', {
    'task': 'Complete CI/CD system with monitoring',
    'multi_domain': True
})
```

**CEO Workflow** :
1. CEO analyse et planifie
2. CEO spawn CTO pour partie technique
3. CTO spawn : `devops-specialist` + `devsecops-specialist`
4. Exécution parallèle
5. CEO synthétise les résultats

---

## 📋 Instructions pour Claude

### À CHAQUE Requête Utilisateur

**Étape 1** : Analyser la requête
```python
analysis = analyze_user_request(user_message)
```

**Étape 2** : Vérifier si spawn nécessaire
```python
if should_activate_agents(analysis):
    # Spawner l'agent approprié
else:
    # Répondre directement
```

**Étape 3** : Logger l'activité
```bash
curl -X POST http://localhost:3000/api/activity/add \
  -H "Content-Type: application/json" \
  -d '{"agent": "AGENT_NAME", "status": "STATUS", "action": "ACTION"}'
```

---

## 🔍 Debug et Monitoring

### Vérifier les Logs d'Activité

```bash
# Voir les dernières activités
tail -f ~/.claude/global_memory/activity_logs/agent_activity.log

# Voir via API
curl http://localhost:3000/api/activity/log
```

### Vérifier le Status Système

```bash
# Health check
curl http://localhost:3000/api/health

# Agent status
curl http://localhost:3000/api/agents
```

---

## 🎯 Critères de Succès

**Le système fonctionne correctement si** :

1. ✅ Tâches simples traitées directement (pas d'overhead inutile)
2. ✅ Tâches techniques spawent automatiquement CTO
3. ✅ Tâches recherche spawent automatiquement CRO
4. ✅ Tâches complexes spawent CEO qui délègue intelligemment
5. ✅ Toutes les activités sont loggées dans le dashboard
6. ✅ L'utilisateur voit une amélioration de qualité sur tâches complexes

---

## ⚙️ Configuration Avancée

### Personnaliser les Seuils

**Fichier** : `~/.claude/global_memory/agent_config.json`

```json
{
  "auto_activation": {
    "enabled": true,
    "complexity_threshold": 2,
    "always_spawn_for_keywords": ["architecture", "ci/cd", "system design"],
    "never_spawn_for_keywords": ["simple", "quick", "just show"],
    "prefer_direct_response": false
  },
  "delegation_strategy": {
    "ceo_for_multi_domain": true,
    "parallel_execution": true,
    "max_concurrent_agents": 5
  }
}
```

---

## 📊 Métriques

**Tracker l'efficacité du système** :

- Nombre de spawns automatiques vs manuels
- Temps de réponse avec/sans agents
- Satisfaction utilisateur (implicite via feedback)
- Taux de réussite des délégations

---

## 🚀 Évolutions Futures

### Phase 2 : Machine Learning

- Apprentissage des patterns de spawn efficaces
- Ajustement automatique des seuils
- Prédiction de la meilleure stratégie d'agent

### Phase 3 : Contexte de Session

- Mémoire des agents utilisés récemment
- Continuité entre requêtes liées
- Optimisation basée sur l'historique utilisateur

---

**Version** : 1.0
**Status** : ✅ GUIDE COMPLET
**Prochaine étape** : Implémentation dans la boucle principale de Claude

🤖 **Auto-activation prête à être déployée !**
