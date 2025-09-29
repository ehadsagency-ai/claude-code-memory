# Claude Code CEO - Professional Configuration Manager
# Docker Image for One-Click Deployment

FROM python:3.11-slim

LABEL maintainer="ehadsagency-ai <ehads.agency@gmail.com>"
LABEL description="Claude Code CEO Professional Configuration Manager"
LABEL version="1.0.0"

# Configuration de l'environnement
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=server.py
ENV FLASK_ENV=production
ENV CLAUDE_HOME=/app/.claude
ENV MEMORY_DIR=/app/.claude/global_memory

# Mise à jour du système et installation des dépendances système
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    rsync \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Création de l'utilisateur claude (non-root pour sécurité)
RUN useradd -m -u 1000 claude && \
    mkdir -p /app && \
    chown -R claude:claude /app

# Copie des requirements Python
COPY requirements.txt /app/

# Installation des dépendances Python
RUN pip install --no-cache-dir -r /app/requirements.txt

# Basculer vers l'utilisateur claude
USER claude
WORKDIR /app

# Création de la structure de répertoires
RUN mkdir -p \
    .claude/global_memory/{error_patterns,architectures,optimizations,project_templates,decision_history} \
    .claude/global_memory/{sync_scripts,setup_guides,install_scripts,ui} \
    .claude/global_memory/docker

# Copie des fichiers de configuration et interface
COPY --chown=claude:claude ui/ .claude/global_memory/ui/
COPY --chown=claude:claude sync_scripts/ .claude/global_memory/sync_scripts/
COPY --chown=claude:claude setup_guides/ .claude/global_memory/setup_guides/
COPY --chown=claude:claude install_scripts/ .claude/global_memory/install_scripts/
COPY --chown=claude:claude *.json .claude/global_memory/
COPY --chown=claude:claude *.md .claude/global_memory/

# Copie des configurations Claude Code
COPY --chown=claude:claude claude_config/ .claude/

# Permissions pour les scripts
RUN chmod +x .claude/global_memory/sync_scripts/*.sh && \
    chmod +x .claude/global_memory/install_scripts/*.sh && \
    chmod +x .claude/global_memory/ui/launch.sh

# Script d'initialisation
COPY --chown=claude:claude docker/init.sh /app/init.sh
RUN chmod +x /app/init.sh

# Configuration Git globale
RUN git config --global user.name "ehadsagency-ai" && \
    git config --global user.email "ehads.agency@gmail.com"

# Variables d'environnement pour l'application
ENV GITHUB_USER=ehadsagency-ai
ENV GITHUB_EMAIL=ehads.agency@gmail.com
ENV GITHUB_REPO=claude-code-memory

# Exposition du port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5000/api/status || exit 1

# Point d'entrée
ENTRYPOINT ["/app/init.sh"]

# Commande par défaut
CMD ["python", ".claude/global_memory/ui/server.py"]