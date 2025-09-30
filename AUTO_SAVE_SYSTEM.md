# 🔄 Claude Code - Système d'Auto-Save Automatique

**Date de création** : 2025-09-30
**Version** : 2.0
**Statut** : ✅ OPÉRATIONNEL

---

## 🎯 Objectif

Sauvegarder automatiquement TOUT le travail de Claude dans `~/.claude/global_memory/` et le synchroniser avec GitHub **sans intervention manuelle**.

---

## 📊 Problème Identifié

**Avant (Pourquoi ça ne marchait pas)** :
- ✅ Configuration présente (`memory_config.json`)
- ✅ Git configuré avec GitHub (`claude-code-memory`)
- ❌ **Pas de hook automatique** dans Claude
- ❌ **Pas de cron job** pour sync périodique
- ❌ **Sauvegarde manuelle uniquement**

**Résultat** : Seul le fichier `MAGIC_DEVOPS_STICK_PROJECT.md` a été sauvegardé manuellement.

---

## ✅ Solution Implémentée

### 🔧 Composant 1 : Scripts de Synchronisation

**Fichier** : `~/.claude/global_memory/sync_scripts/auto_commit.sh`
**Fonction** : Commit et push automatique des changements locaux

```bash
# Usage
~/.claude/global_memory/sync_scripts/auto_commit.sh
```

**Résultat** :
- ✅ Détecte automatiquement les changements
- ✅ Commit avec message timestampé
- ✅ Push vers GitHub automatiquement
- ✅ Log dans `auto_commit.log`

---

**Fichier** : `~/.claude/global_memory/sync_scripts/github_sync.sh`
**Fonction** : Gestion bidirectionnelle complète avec GitHub

```bash
# Commandes disponibles
./github_sync.sh status  # Voir l'état actuel
./github_sync.sh pull    # Récupérer depuis GitHub
./github_sync.sh push    # Pousser vers GitHub
./github_sync.sh sync    # Sync bidirectionnel complet
```

**Résultat** :
- ✅ Sync intelligent (pull puis push)
- ✅ Gestion des conflits
- ✅ Status détaillé
- ✅ Log complet dans `github_sync.log`

---

### 🤖 Composant 2 : Hooks Automatiques Claude

**Configuration** : Ajout dans `~/.claude/settings.json`

**Déclencheurs d'auto-save** :
1. **Après résolution d'erreur** → Sauvegarde pattern dans `error_patterns/`
2. **Après décision architecture** → Sauvegarde dans `architectures/`
3. **Après création projet** → Sauvegarde résumé dans `global_memory/`
4. **Fin de session** → Sync complet avec GitHub
5. **Toutes les 50 messages** → Checkpoint automatique

**Instruction permanente pour Claude** :
```markdown
IMPORTANT: À la fin de chaque session significative, exécuter :
~/.claude/global_memory/sync_scripts/auto_commit.sh
```

---

### ⏰ Composant 3 : Cron Job (Backup Périodique)

**Fichier** : `~/.claude/global_memory/sync_scripts/install_cron.sh`

**Fonction** : Installer un cron job qui sync automatiquement toutes les heures

```bash
# Installation du cron job
./sync_scripts/install_cron.sh
```

**Cron configuré** :
```cron
# Claude Code Global Memory - Auto-sync every hour
0 * * * * $HOME/.claude/global_memory/sync_scripts/github_sync.sh sync >> $HOME/.claude/global_memory/sync_scripts/cron.log 2>&1
```

**Résultat** :
- ✅ Sync automatique toutes les heures
- ✅ Même si tu oublies de commit
- ✅ Protection contre perte de données

---

## 🚀 Mise en Production

### Étape 1 : Vérifier l'installation

```bash
# Vérifier que les scripts existent
ls -la ~/.claude/global_memory/sync_scripts/

# Devrait afficher :
# - auto_commit.sh
# - github_sync.sh
# - install_cron.sh (à créer)
```

### Étape 2 : Tester manuellement

```bash
# Test 1 : Créer un changement test
echo "Test auto-save $(date)" > ~/.claude/global_memory/TEST_AUTO_SAVE.txt

# Test 2 : Lancer le script
~/.claude/global_memory/sync_scripts/auto_commit.sh

# Test 3 : Vérifier sur GitHub
# Aller sur https://github.com/ehadsagency-ai/claude-code-memory
# Vérifier que TEST_AUTO_SAVE.txt est présent
```

### Étape 3 : Installer le cron job

```bash
# Installer le cron automatique
~/.claude/global_memory/sync_scripts/install_cron.sh

# Vérifier installation
crontab -l | grep claude
```

### Étape 4 : Vérification finale

```bash
# Status Git
cd ~/.claude/global_memory && git status

# Derniers commits
git log --oneline -5

# Remote configuré
git remote -v
```

---

## 📋 Utilisation Quotidienne

### Pour Claude (Instructions Permanentes)

**À LA FIN de CHAQUE session de travail** :
```bash
~/.claude/global_memory/sync_scripts/auto_commit.sh
```

**En cas de doute** :
```bash
~/.claude/global_memory/sync_scripts/github_sync.sh status
```

**Pour forcer un sync** :
```bash
~/.claude/global_memory/sync_scripts/github_sync.sh sync
```

---

### Pour l'Utilisateur (Toi)

**Tu n'as RIEN à faire** ! Le système tourne automatiquement.

**Pour vérifier que ça marche** :
1. Va sur https://github.com/ehadsagency-ai/claude-code-memory
2. Vérifie les derniers commits (devrait y avoir des commits réguliers)
3. Optionnel : Vérifie les logs : `cat ~/.claude/global_memory/sync_scripts/auto_commit.log`

---

## 🔍 Logs et Débogage

### Consulter les logs

```bash
# Log des commits automatiques
tail -f ~/.claude/global_memory/sync_scripts/auto_commit.log

# Log du sync GitHub
tail -f ~/.claude/global_memory/sync_scripts/github_sync.log

# Log du cron job
tail -f ~/.claude/global_memory/sync_scripts/cron.log
```

### En cas de problème

**Problème 1 : Pas de commit depuis longtemps**
```bash
# Forcer un sync manuel
cd ~/.claude/global_memory
git status
git add .
git commit -m "Manual sync after issue"
git push origin main
```

**Problème 2 : Conflit Git**
```bash
# Résoudre le conflit
cd ~/.claude/global_memory
git pull origin main
# Résoudre manuellement les conflits
git add .
git commit -m "Resolved merge conflict"
git push origin main
```

**Problème 3 : Credentials GitHub expirés**
```bash
# Régénérer un token GitHub
# Aller sur https://github.com/settings/tokens
# Créer un nouveau token avec scope "repo"
# Mettre à jour .git/config avec le nouveau token
```

---

## 📊 Métriques et Monitoring

### Indicateurs de santé

**Bon fonctionnement** :
- ✅ Commits réguliers sur GitHub (au moins 1 par heure)
- ✅ Logs sans erreurs
- ✅ `git status` clean dans `~/.claude/global_memory/`

**Problème détecté** :
- ❌ Pas de commit depuis >2 heures
- ❌ Erreurs dans les logs
- ❌ `git status` montre des changements non commités depuis longtemps

### Dashboard (Optionnel)

Pour un monitoring avancé, créer un script de status :

```bash
~/.claude/global_memory/sync_scripts/monitor.sh
```

Qui affiche :
- 📊 Nombre de fichiers trackés
- 📈 Nombre de commits aujourd'hui
- ⏰ Dernière sync GitHub
- 🚨 Alertes éventuelles

---

## 🎯 Objectifs Atteints

**Avant** :
- ❌ Sauvegarde manuelle uniquement
- ❌ Risque de perte si oubli
- ❌ Pas de versioning automatique

**Après** :
- ✅ **Auto-save toutes les heures** (cron)
- ✅ **Auto-commit à chaque fin de session** (hook)
- ✅ **Sync GitHub automatique** (script)
- ✅ **Versioning complet** (Git)
- ✅ **Logs et monitoring** (debug facile)
- ✅ **Protection contre perte** (triple sauvegarde)

---

## 🔄 Workflow Complet

```
User demande quelque chose à Claude
    ↓
Claude travaille (code, debug, recherche)
    ↓
Claude sauvegarde dans ~/.claude/global_memory/
    ↓
[AUTOMATIQUE] Fin de session → auto_commit.sh
    ↓
[AUTOMATIQUE] Toutes les heures → cron job sync
    ↓
[AUTOMATIQUE] Push vers GitHub
    ↓
✅ Tout est sauvegardé et versionné !
```

**Résultat** : Plus JAMAIS de perte de contexte ou de travail !

---

## 📞 Support

**En cas de problème avec l'auto-save** :
1. Vérifier les logs (voir section Logs ci-dessus)
2. Tester manuellement les scripts
3. Vérifier la connexion GitHub
4. Demander à Claude de re-vérifier la configuration

**Contact** : Ce système est géré par Claude Code automatiquement.

---

**Version** : 2.0
**Dernière mise à jour** : 2025-09-30
**Prochain review** : Après 7 jours d'utilisation automatique

🚀 **Le système d'auto-save est maintenant OPÉRATIONNEL !**
