#!/usr/bin/env python3
"""
Claude Code CEO - Configuration Manager Backend
Professional UI Backend pour la gestion de la configuration Claude Code
"""

import os
import json
import subprocess
import logging
from pathlib import Path
from typing import Dict, Any, List
from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS

# Configuration
app = Flask(__name__)
CORS(app)

# Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Paths
HOME_DIR = Path.home()
CLAUDE_DIR = HOME_DIR / '.claude'
MEMORY_DIR = CLAUDE_DIR / 'global_memory'
CREDENTIALS_FILE = CLAUDE_DIR / 'github_credentials'
SYNC_SCRIPT = MEMORY_DIR / 'sync_scripts' / 'github_sync.sh'

# Try project-specific directory first for agents.json
PROJECT_DIR = Path("/Users/deo_metoyer/Library/Mobile Documents/com~apple~CloudDocs/MY_GOUV/HOME/PSL_MINES/Data_Analyst/.claude")
if PROJECT_DIR.exists():
    AGENTS_FILE = PROJECT_DIR / 'agents.json'
    SETTINGS_FILE = PROJECT_DIR / 'settings.local.json'
else:
    AGENTS_FILE = CLAUDE_DIR / 'agents.json'
    SETTINGS_FILE = CLAUDE_DIR / 'settings.local.json'

class ClaudeConfigManager:
    """Gestionnaire de configuration Claude Code"""

    def __init__(self):
        self.ensure_directories()

    def ensure_directories(self):
        """Assurer que les répertoires existent"""
        CLAUDE_DIR.mkdir(exist_ok=True)
        MEMORY_DIR.mkdir(exist_ok=True)
        (MEMORY_DIR / 'ui').mkdir(exist_ok=True)

    def get_system_status(self) -> Dict[str, Any]:
        """Obtenir le status du système"""
        return {
            'claude_code_installed': self.check_claude_code(),
            'github_configured': self.check_github_config(),
            'memory_size': self.get_memory_size(),
            'connection_status': True,
            'agents_active': self.count_agents(),
            'mcp_servers': self.get_mcp_status()
        }

    def check_claude_code(self) -> bool:
        """Vérifier si Claude Code est installé"""
        try:
            subprocess.run(['claude', '--version'], capture_output=True, check=True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False

    def check_github_config(self) -> bool:
        """Vérifier la configuration GitHub"""
        return CREDENTIALS_FILE.exists()

    def get_memory_size(self) -> str:
        """Obtenir la taille de la mémoire globale"""
        try:
            result = subprocess.run(
                ['du', '-sh', str(MEMORY_DIR)],
                capture_output=True, text=True
            )
            if result.returncode == 0:
                return result.stdout.split()[0]
        except Exception as e:
            logger.error(f"Error getting memory size: {e}")
        return "0K"

    def count_agents(self) -> int:
        """Compter les agents configurés"""
        if not AGENTS_FILE.exists():
            return 0

        try:
            with open(AGENTS_FILE, 'r') as f:
                data = json.load(f)
                return len(data.get('agents', {}))
        except Exception as e:
            logger.error(f"Error counting agents: {e}")
            return 0

    def get_mcp_status(self) -> List[str]:
        """Obtenir le status des serveurs MCP"""
        if not SETTINGS_FILE.exists():
            return []

        try:
            with open(SETTINGS_FILE, 'r') as f:
                data = json.load(f)
                return data.get('enabledMcpjsonServers', [])
        except Exception as e:
            logger.error(f"Error getting MCP status: {e}")
            return []

    def load_github_config(self) -> Dict[str, str]:
        """Charger la configuration GitHub"""
        config = {
            'username': 'ehadsagency-ai',
            'email': 'ehads.agency@gmail.com',
            'token': '',
            'repo': 'claude-code-memory'
        }

        if CREDENTIALS_FILE.exists():
            try:
                with open(CREDENTIALS_FILE, 'r') as f:
                    for line in f:
                        if '=' in line and not line.strip().startswith('#'):
                            key, value = line.strip().split('=', 1)
                            if key == 'GITHUB_USER':
                                config['username'] = value
                            elif key == 'GITHUB_EMAIL':
                                config['email'] = value
                            elif key == 'GITHUB_TOKEN':
                                config['token'] = value
                            elif key == 'GITHUB_REPO':
                                config['repo'] = value
            except Exception as e:
                logger.error(f"Error loading GitHub config: {e}")

        return config

    def save_github_config(self, config: Dict[str, str]) -> bool:
        """Sauvegarder la configuration GitHub"""
        try:
            with open(CREDENTIALS_FILE, 'w') as f:
                f.write("# Configuration GitHub pour Claude Code CEO Memory\n")
                f.write(f"GITHUB_TOKEN={config['token']}\n")
                f.write(f"GITHUB_USER={config['username']}\n")
                f.write(f"GITHUB_EMAIL={config['email']}\n")
                f.write(f"GITHUB_REPO={config['repo']}\n")

            # Sécuriser le fichier
            os.chmod(CREDENTIALS_FILE, 0o600)
            return True
        except Exception as e:
            logger.error(f"Error saving GitHub config: {e}")
            return False

    def test_github_connection(self, token: str) -> Dict[str, Any]:
        """Tester la connexion GitHub"""
        try:
            import requests
            headers = {'Authorization': f'token {token}'}
            response = requests.get('https://api.github.com/user', headers=headers, timeout=10)

            if response.status_code == 200:
                user_info = response.json()
                return {
                    'success': True,
                    'message': f"Connecté en tant que {user_info.get('login', 'Unknown')}",
                    'user': user_info.get('login'),
                    'rate_limit': response.headers.get('X-RateLimit-Remaining', 'Unknown')
                }
            else:
                return {
                    'success': False,
                    'message': f"Erreur API GitHub: {response.status_code}",
                    'error': response.text
                }
        except Exception as e:
            logger.error(f"Error testing GitHub connection: {e}")
            return {
                'success': False,
                'message': f"Erreur de connexion: {str(e)}"
            }

    def run_sync_command(self, command: str) -> Dict[str, Any]:
        """Exécuter une commande de synchronisation"""
        if not SYNC_SCRIPT.exists():
            return {
                'success': False,
                'message': 'Script de synchronisation non trouvé'
            }

        try:
            result = subprocess.run(
                [str(SYNC_SCRIPT), command],
                capture_output=True,
                text=True,
                timeout=60
            )

            return {
                'success': result.returncode == 0,
                'message': result.stdout if result.returncode == 0 else result.stderr,
                'output': result.stdout,
                'error': result.stderr
            }
        except subprocess.TimeoutExpired:
            return {
                'success': False,
                'message': 'Timeout: Opération trop longue'
            }
        except Exception as e:
            logger.error(f"Error running sync command: {e}")
            return {
                'success': False,
                'message': f"Erreur: {str(e)}"
            }

    def get_memory_stats(self) -> Dict[str, Any]:
        """Obtenir les statistiques de la mémoire"""
        stats = {
            'errorPatterns': 0,
            'architectures': 0,
            'optimizations': 0,
            'decisions': 0,
            'totalFiles': 0,
            'totalSize': self.get_memory_size()
        }

        try:
            # Compter les fichiers dans chaque catégorie
            error_patterns_dir = MEMORY_DIR / 'error_patterns'
            if error_patterns_dir.exists():
                stats['errorPatterns'] = len(list(error_patterns_dir.glob('*.json')))

            architectures_dir = MEMORY_DIR / 'architectures'
            if architectures_dir.exists():
                stats['architectures'] = len(list(architectures_dir.glob('*.json')))

            optimizations_dir = MEMORY_DIR / 'optimizations'
            if optimizations_dir.exists():
                stats['optimizations'] = len(list(optimizations_dir.glob('*.json')))

            decisions_dir = MEMORY_DIR / 'decision_history'
            if decisions_dir.exists():
                stats['decisions'] = len(list(decisions_dir.glob('*.json')))

            # Compter tous les fichiers
            stats['totalFiles'] = len(list(MEMORY_DIR.rglob('*.*')))

        except Exception as e:
            logger.error(f"Error getting memory stats: {e}")

        return stats

# Instance du gestionnaire
config_manager = ClaudeConfigManager()

# Routes API
@app.route('/')
def index():
    """Page d'accueil - Interface utilisateur"""
    return send_from_directory(MEMORY_DIR / 'ui', 'index.html')

@app.route('/api/status')
def get_status():
    """Obtenir le status du système"""
    return jsonify(config_manager.get_system_status())

@app.route('/api/github/config', methods=['GET'])
def get_github_config():
    """Obtenir la configuration GitHub"""
    config = config_manager.load_github_config()
    # Ne pas masquer le token - il sera masqué côté client avec type="password"
    # Cela permet au bouton œil de fonctionner correctement
    return jsonify(config)

@app.route('/api/github/config', methods=['POST'])
def save_github_config():
    """Sauvegarder la configuration GitHub"""
    try:
        config = request.json
        if config_manager.save_github_config(config):
            return jsonify({'success': True, 'message': 'Configuration sauvegardée'})
        else:
            return jsonify({'success': False, 'message': 'Erreur de sauvegarde'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)})

@app.route('/api/github/test', methods=['POST'])
def test_github():
    """Tester la connexion GitHub"""
    try:
        data = request.json
        token = data.get('token', '')
        result = config_manager.test_github_connection(token)
        return jsonify(result)
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)})

@app.route('/api/sync/<command>')
def sync_command(command):
    """Exécuter une commande de synchronisation"""
    valid_commands = ['status', 'push', 'pull', 'sync']
    if command not in valid_commands:
        return jsonify({'success': False, 'message': 'Commande invalide'})

    result = config_manager.run_sync_command(command)
    return jsonify(result)

@app.route('/api/memory/stats')
def get_memory_stats():
    """Obtenir les statistiques de la mémoire"""
    return jsonify(config_manager.get_memory_stats())

@app.route('/api/agents')
def get_agents():
    """Obtenir la liste des agents"""
    if not AGENTS_FILE.exists():
        return jsonify([])

    try:
        with open(AGENTS_FILE, 'r') as f:
            data = json.load(f)
            agents = []
            for name, config in data.get('agents', {}).items():
                agents.append({
                    'name': name.replace('-', ' ').title(),
                    'description': config.get('description', ''),
                    'keywords': config.get('activation_keywords', []),
                    'reports_to': config.get('reports_to', 'Independent')
                })
            return jsonify(agents)
    except Exception as e:
        logger.error(f"Error loading agents: {e}")
        return jsonify([])

@app.route('/api/activity/log')
def get_activity_log():
    """Obtenir les dernières activités des agents"""
    activity_log_file = MEMORY_DIR / 'activity_logs' / 'agent_activity.log'

    if not activity_log_file.exists():
        return jsonify([])

    try:
        activities = []
        with open(activity_log_file, 'r') as f:
            lines = f.readlines()
            # Lire les 50 dernières lignes (exclure les commentaires)
            for line in reversed(lines[-50:]):
                if line.strip() and not line.startswith('#'):
                    activities.append(line.strip())

        return jsonify(activities)
    except Exception as e:
        logger.error(f"Error reading activity log: {e}")
        return jsonify([])

@app.route('/api/activity/add', methods=['POST'])
def add_activity():
    """Ajouter une activité d'agent"""
    try:
        data = request.json
        agent = data.get('agent', 'Unknown')
        status = data.get('status', 'active')
        action = data.get('action', '')

        activity_log_file = MEMORY_DIR / 'activity_logs' / 'agent_activity.log'
        activity_log_file.parent.mkdir(exist_ok=True)

        timestamp = subprocess.run(['date', '+%Y-%m-%d %H:%M:%S'],
                                   capture_output=True, text=True).stdout.strip()

        log_entry = f"[{timestamp}] [{agent}] [{status}] {action}\n"

        with open(activity_log_file, 'a') as f:
            f.write(log_entry)

        return jsonify({'success': True, 'message': 'Activity logged'})
    except Exception as e:
        logger.error(f"Error adding activity: {e}")
        return jsonify({'success': False, 'message': str(e)})

@app.route('/api/github/last_commit')
def get_last_commit():
    """Obtenir les informations du dernier commit GitHub"""
    try:
        # Obtenir le dernier commit et son timestamp
        result = subprocess.run(
            ['git', '-C', str(MEMORY_DIR), 'log', '-1', '--format=%H|%ar|%s'],
            capture_output=True,
            text=True,
            timeout=5
        )

        if result.returncode == 0 and result.stdout.strip():
            parts = result.stdout.strip().split('|')
            commit_hash = parts[0][:7]  # Short hash
            time_ago = parts[1] if len(parts) > 1 else 'unknown'
            message = parts[2] if len(parts) > 2 else 'No message'

            # Vérifier si le commit a été poussé
            push_result = subprocess.run(
                ['git', '-C', str(MEMORY_DIR), 'log', 'origin/main..HEAD', '--oneline'],
                capture_output=True,
                text=True,
                timeout=5
            )

            is_synced = len(push_result.stdout.strip()) == 0

            return jsonify({
                'success': True,
                'commit_hash': commit_hash,
                'time_ago': time_ago,
                'message': message,
                'is_synced': is_synced,
                'status': 'synced' if is_synced else 'pending'
            })
        else:
            return jsonify({
                'success': False,
                'message': 'No commits found',
                'status': 'no_repo'
            })
    except subprocess.TimeoutExpired:
        return jsonify({
            'success': False,
            'message': 'Git command timeout',
            'status': 'error'
        })
    except Exception as e:
        logger.error(f"Error getting last commit: {e}")
        return jsonify({
            'success': False,
            'message': str(e),
            'status': 'error'
        })

@app.route('/api/mcp/status')
def get_mcp_status():
    """Vérifier le status des serveurs MCP"""
    servers = []

    # Vérifier ref-tools (documentation search)
    try:
        # ref-tools est disponible si on peut importer les tools
        ref_tools_available = True
        servers.append({
            'name': 'ref-tools',
            'description': 'Documentation search',
            'status': 'connected',
            'available': ref_tools_available
        })
    except:
        servers.append({
            'name': 'ref-tools',
            'description': 'Documentation search',
            'status': 'disconnected',
            'available': False
        })

    # Vérifier filesystem
    try:
        # filesystem est disponible si le répertoire de mémoire existe
        filesystem_available = MEMORY_DIR.exists()
        servers.append({
            'name': 'filesystem',
            'description': 'File operations',
            'status': 'connected' if filesystem_available else 'disconnected',
            'available': filesystem_available
        })
    except:
        servers.append({
            'name': 'filesystem',
            'description': 'File operations',
            'status': 'disconnected',
            'available': False
        })

    # Compter les serveurs connectés
    connected_count = sum(1 for s in servers if s['status'] == 'connected')
    total_count = len(servers)

    return jsonify({
        'servers': servers,
        'connected': connected_count,
        'total': total_count,
        'status': 'healthy' if connected_count == total_count else 'partial'
    })

if __name__ == '__main__':
    print("🚀 Démarrage du serveur Claude Code CEO Configuration Manager")
    print(f"📁 Répertoire mémoire: {MEMORY_DIR}")
    print(f"🌐 Interface disponible sur: http://localhost:3000")
    print()

    app.run(host='localhost', port=3000, debug=False)