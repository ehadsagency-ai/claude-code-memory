# 🚀 Guide d'Utilisation - DEO Claude Code CEO sur USB

**Version Portable Complète - Digital Executive Officer**

## 📋 Avant de Commencer

### 💾 **Préparation de la Clé USB**
1. **Formatage** : FAT32 ou exFAT (compatibilité universelle)
2. **Taille** : Minimum 16 GB recommandé
3. **Nom** : "DEO_CLAUDE_CODE" (optionnel mais professionnel)
4. **Copie complète** du contenu de ce dossier sur la racine USB

### 🔧 **Contenu à Copier sur USB**
```
Votre_Cle_USB/
├── autorun.inf
├── DEMARRER_DEO_WINDOWS.bat
├── DEMARRER_DEO_MACOS.command
├── DEMARRER_DEO_LINUX.sh
├── README.md
├── GUIDE_UTILISATION_USB.md
├── windows/ (scripts et runtimes Windows)
├── macos/ (scripts et runtimes macOS)
├── linux/ (scripts et runtimes Linux)
├── core/ (configuration Claude Code CEO)
└── data/ (données utilisateur)
```

## 🖥️ Installation Windows

### 🔴 **Méthode Automatique (Recommandée)**
1. **Insérer la clé USB**
2. **Attendre l'autorun** (si activé dans Windows)
3. **Ou double-cliquer** `DEMARRER_DEO_WINDOWS.bat`
4. **Accepter UAC** si demandé (privilèges admin requis)
5. **Suivre l'installation** automatique
6. **Admirer la bannière DEO** ! 🎊

### 🟡 **Installation Manuelle**
```batch
# Ouvrir PowerShell en admin
cd X:\  # X = lettre de votre clé USB
.\DEMARRER_DEO_WINDOWS.bat
```

### 🔵 **Ce qui sera Installé**
- ✅ Docker Desktop (si absent)
- ✅ Python portable (depuis USB ou téléchargement)
- ✅ Git portable (depuis USB ou téléchargement)
- ✅ Configuration Claude Code CEO complète
- ✅ Interface web + API
- ✅ Agents hiérarchiques CEO/CTO/CRO

## 🍎 Installation macOS

### 🔴 **Méthode Recommandée**
1. **Insérer la clé USB**
2. **Double-cliquer** `DEMARRER_DEO_MACOS.command`
3. **Autoriser l'exécution** si macOS le demande
4. **Saisir mot de passe** admin quand demandé
5. **Installation automatique** de tous composants
6. **Bannière DEO spectaculaire** ! 🚀

### 🟡 **Installation Terminal**
```bash
cd /Volumes/DEO_CLAUDE_CODE/  # Nom de votre USB
chmod +x DEMARRER_DEO_MACOS.command
./DEMARRER_DEO_MACOS.command
```

### 🔵 **Composants macOS**
- ✅ Docker Desktop for Mac
- ✅ Homebrew (si absent)
- ✅ Python 3.11+
- ✅ Git (déjà présent sur macOS)
- ✅ Configuration complète DEO

## 🐧 Installation Linux

### 🔴 **Ubuntu/Debian**
```bash
cd /media/$USER/DEO_CLAUDE_CODE/  # Chemin de montage USB
chmod +x DEMARRER_DEO_LINUX.sh
sudo ./DEMARRER_DEO_LINUX.sh
```

### 🟡 **Fedora/CentOS**
```bash
cd /run/media/$USER/DEO_CLAUDE_CODE/
chmod +x DEMARRER_DEO_LINUX.sh
sudo ./DEMARRER_DEO_LINUX.sh
```

### 🔵 **Installation Générique**
Le script détecte automatiquement votre distribution et installe :
- ✅ Docker + Docker Compose
- ✅ Python 3 + pip
- ✅ Git + curl
- ✅ Configuration Claude Code CEO

## 🎯 Post-Installation

### ✅ **Vérification Installation**
Après l'installation, vous devriez voir la bannière DEO :
```
╔════════════════════════════════════════════════════╗
║  🚀 DIGITAL EXECUTIVE OFFICER 🚀                  ║
║  ✅ Installation Complete                          ║
║  👤 ehadsagency-ai Ready                           ║
╚════════════════════════════════════════════════════╝
```

### 🌐 **Accès Interface Web**
- **URL locale** : http://localhost:3000
- **Dashboard** : Configuration GitHub, gestion mémoire
- **Monitoring** : Statut agents, sync GitHub

### 🔧 **Configuration GitHub**
1. **Interface web** → Section GitHub
2. **Saisir token** personnel GitHub
3. **Test connexion** automatique
4. **Synchronisation** activée !

## 🚀 Utilisation Avancée

### 💾 **Mode Portable Pur**
Pour utiliser sans installation sur l'ordinateur hôte :
1. **Ne pas exécuter** les scripts d'installation
2. **Naviguer vers** `core/ui/`
3. **Lancer** `python3 server.py` depuis USB
4. **Accéder** http://localhost:5000

### 🔄 **Synchronisation Multi-Machines**
Vos configurations sont sauvées sur USB :
- **data/user-configs/** : Vos paramètres personnels
- **data/cache/** : Cache projets et patterns
- **data/logs/** : Historique d'utilisation

### 🧠 **Mémoire CEO Global**
Le système DEO maintient une mémoire persistante :
- **Patterns d'erreurs** résolues
- **Architectures projets** optimisées
- **Optimisations code** automatiques
- **Décisions techniques** archivées

## 🔒 Sécurité & Confidentialité

### ✅ **Données Sécurisées**
- ❌ **Aucune trace** sur l'ordinateur hôte après déconnexion USB
- ✅ **Credentials chiffrés** sur la clé USB
- ✅ **Exécution sandboxée** via Docker
- ✅ **Isolation complète** des données

### 🧹 **Nettoyage Auto**
À la déconnexion USB, le système :
- Sauvegarde automatiquement les configurations
- Nettoie les fichiers temporaires
- Archive les logs dans data/
- Prépare la prochaine utilisation

## 🛟 Dépannage

### ⚠️ **Problèmes Courants**

#### Windows : "Autorun désactivé"
```batch
# Double-cliquer manuellement
DEMARRER_DEO_WINDOWS.bat
```

#### macOS : "Fichier non autorisé"
```bash
# Aller dans Système > Sécurité > Autoriser
# Ou en terminal :
sudo xattr -rd com.apple.quarantine DEMARRER_DEO_MACOS.command
```

#### Linux : "Permission denied"
```bash
chmod +x DEMARRER_DEO_LINUX.sh
sudo ./DEMARRER_DEO_LINUX.sh
```

#### Docker : "Service not started"
```bash
# Windows/Mac : Lancer Docker Desktop manuellement
# Linux :
sudo systemctl start docker
sudo systemctl enable docker
```

### 🆘 **Support Technique**
- **GitHub** : https://github.com/ehadsagency-ai/claude-code-memory/issues
- **Email** : ehads.agency@gmail.com
- **Documentation** : README.md sur la clé USB

## 🌟 Fonctionnalités Avancées

### 🎯 **Mode Développeur**
```bash
# Depuis votre USB monté
cd core/
./sync_scripts/github_sync.sh sync    # Sync bidirectionnelle
./docker/deploy.sh                    # Déploiement local
```

### 📊 **Monitoring Système**
```bash
# Vérifier statut agents
curl http://localhost:3000/api/agents

# Statistiques mémoire
curl http://localhost:3000/api/memory/stats

# Historique sync
curl http://localhost:3000/api/sync/history
```

### 🔧 **Personnalisation**
Éditez `data/user-configs/deo-settings.json` pour :
- Modifier les couleurs de bannière
- Personnaliser les agents
- Configurer auto-sync GitHub
- Définir raccourcis personnalisés

---

## 🎊 **Votre Claude Code DEO est Prêt !**

**Avec cette clé USB, vous avez maintenant :**
- 🧠 **CEO Global Memory** accessible partout
- 👥 **Agents hiérarchiques** professionnels
- 🔄 **Sync GitHub** automatique
- 🌐 **Interface web** moderne
- 🐳 **Docker** containerisé
- 🎨 **Bannière DEO** personnalisée

**Branchez, installez, développez - Partout, tout le temps ! 🚀**

---

**Made with ❤️ by Digital Executive Officer**
**👤 ehadsagency-ai | 📧 ehads.agency@gmail.com**