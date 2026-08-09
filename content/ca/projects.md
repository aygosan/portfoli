---
title: "Projectes"
date: 2026-08-09
draft: false
---

## Projectes

### TekGarden — Plataforma Auto-Gestionada

**Rol:** Arquitecte i únic operador

Un homelab convertit en plataforma de grau de producció funcionant sobre Proxmox amb Kubernetes, GitOps i observabilitat completa.

**Què fa:**
- 2 clústers HA de Kubernetes (Vega producció + Orion staging) — 12 nodes en total
- 3 hosts Docker executant 30+ serveis
- Desplegaments GitOps via FluxCD (6 repos, reconcilia cada 1m)
- Stack d'observabilitat completa (Grafana, Prometheus, Loki, Alertmanager → Telegram)
- Infraestructura com a Codi amb Ansible (mode pull) i OpenTofu
- Secrets via 1Password + SOPS/age + policies Kyverno
- Backups a Proxmox PBS + Backblaze B2

**Tecnologies:** k3s, FluxCD, Proxmox VE, Traefik, cert-manager, MetalLB, Grafana, Ansible, OpenTofu, Docker, 1Password, Kyverno, CrowdSec, pfSense, Cloudflare

**Destacats:**
- Tot declaratiu — sense canvis manuals d'infraestructura
- Tots els canvis via PR → merge → FluxCD aplica
- Forgejo self-hosted + runners de CI al VPS de Hetzner
- Pipeline d'alertes d'infraestructura a Telegram
- Documentació tractada com a infraestructura (MkDocs, Diátaxis)

---

### openclaw — Rumi, el bot de Minecraft

**Rol:** Arquitecte i desenvolupador

Un bot de Minecraft construït amb [Mineflayer](https://github.com/PrismarineJS/mineflayer) i exposat com a servidor MCP (Model Context Protocol), permetent que agents LLM percebin i actuïn al món del joc.

**Què fa:**
- Bot autònom de Minecraft amb pathfinding, construcció i xat
- Interfície de servidor MCP perquè agents LLM puguin cridar accions del joc com a tools
- Viu al seu propi repo gestionat per GitOps amb serveis LXC

**Tecnologies:** Node.js, Mineflayer, MCP, TypeScript

**Destacats:**
- Connecta agents LLM amb un món de joc en temps real via un protocol estàndard
- Un laboratori per a AI agentic en entorns reals amb estat

---

*More projectes coming soon.*