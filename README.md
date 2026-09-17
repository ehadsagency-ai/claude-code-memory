# Claude Code Memory

[![Stars](https://img.shields.io/github/stars/ehadsagency-ai/claude-code-memory?style=social)](https://github.com/ehadsagency-ai/claude-code-memory)
[![Docker](https://img.shields.io/badge/Docker-one--click-blue.svg)](https://github.com/ehadsagency-ai/claude-code-memory/blob/main/docker/one-click-install.sh)
[![License](https://img.shields.io/badge/license-see%20repo-lightgrey.svg)](LICENSE)

> One-click **Docker** setup that gives [Claude Code](https://github.com/ehadsagency-ai/claude-code-memory) a persistent, cross-project “memory + agent hierarchy” configuration — community tooling, **not** an official Anthropic product.

**Honest metrics (2026-09-17T15:10:00CEST):** ★**1** (only star on the ehadsagency-ai account) · forks 0 · 1 author · 0 commits/7d · **no GitHub Release / GHCR image published** · Hype Score **5/25**.

---

## Value proposition

- **Persistent config** for Claude Code across projects (patterns, playbooks, agent roles)
- **Dockerized** path so you are not hand-editing scattered dotfiles
- Optional **GitHub sync** scripts for moving config between machines
- Small **web UI** (docs: `http://localhost:3000` after deploy) for config / memory visibility

If you want a portable Claude Code “CEO memory” stack in a container, start here. If you need a signed vendor SLA, this is not that.

---

## One-click Docker

```bash
curl -fsSL https://raw.githubusercontent.com/ehadsagency-ai/claude-code-memory/main/docker/one-click-install.sh | bash
```

Prefer to read the script first (recommended):

```bash
git clone https://github.com/ehadsagency-ai/claude-code-memory.git
cd claude-code-memory
less docker/one-click-install.sh
./docker/deploy.sh
```

Optional GitHub token for sync features:

```bash
export GITHUB_TOKEN="ghp_…"   # least-privilege; never commit
./docker/deploy.sh
```

After deploy (per live docs): web UI at **http://localhost:3000** when the stack is up.

---

## Config overview

Live tree (high level):

```
claude-code-memory/
├── docker/           # Dockerfile, compose, one-click-install.sh, deploy.sh
├── ui/               # small web interface
├── sync_scripts/     # github_sync.sh (sync / push / pull / status)
├── architectures/    # project templates
├── error_patterns/   # error playbook store
└── optimizations/    # pattern notes
```

Sync helpers (from live README):

```bash
./sync_scripts/github_sync.sh sync
./sync_scripts/github_sync.sh push
./sync_scripts/github_sync.sh pull
./sync_scripts/github_sync.sh status
```

Documented agent roles include a CEO-style orchestrator plus technical / research / compliance-oriented helpers. Treat role names as **configuration labels**, not a guaranteed multi-agent runtime SLA.

---

## Who it's for

| Audience | Fit |
|----------|-----|
| Claude Code users who want Dockerized, shareable memory/config | Primary |
| Teams exploring hierarchical agent prompts | Experimental / DIY |
| Anyone needing official Anthropic support or compliance certification | **Not** this repo |

---

## Status & metrics honesty

| Item | State |
|------|-------|
| Stars | **1** |
| Releases / GHCR | ❌ none at analysis time |
| Last notable push (canonical scores) | 2025-10-13 |
| “Enterprise / 13MB+ / <2 min install” style claims | **Not independently verified** — omitted as guarantees |
| Official Anthropic product? | **No** — community configuration manager |

---

## Security notes

- Prefer reading `one-click-install.sh` before piping to `bash`.
- Scope `GITHUB_TOKEN` tightly; do not commit tokens.
- Container isolation ≠ threat model review — run only on machines you trust.

---

## Contributing

Solo today. Useful contributions: safer install defaults, GHCR publish (**planned**), docs that separate verified vs aspirational claims, and tests for sync scripts.

```bash
git clone https://github.com/ehadsagency-ai/claude-code-memory.git
cd claude-code-memory
# follow docker/deploy.sh after reviewing scripts
```

Issues/PRs: https://github.com/ehadsagency-ai/claude-code-memory/issues

---

## License

See the repository `LICENSE` file (live README states MIT — confirm in-tree before redistributing).
