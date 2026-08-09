---
title: "Projects"
date: 2026-08-09
draft: false
---

## Projects

### TekGarden — Self-Managed Platform

**Role:** Architect and sole operator

A homelab evolved into a production-grade platform running on Proxmox with Kubernetes, GitOps, and full observability.

**What it does:**
- 2 HA Kubernetes clusters (Vega prod + Orion staging) — 12 nodes total
- 3 Docker hosts running 30+ services
- GitOps deployments via FluxCD (6 repos, reconciles every 1m)
- Full observability stack (Grafana, Prometheus, Loki, Alertmanager → Telegram)
- Infrastructure as Code with Ansible (pull mode) and OpenTofu
- Secrets via 1Password + SOPS/age + Kyverno policies
- Backups to Proxmox PBS + Backblaze B2

**Tech stack:** k3s, FluxCD, Proxmox VE, Traefik, cert-manager, MetalLB, Grafana, Ansible, OpenTofu, Docker, 1Password, Kyverno, CrowdSec, pfSense, Cloudflare

**Highlights:**
- Everything declarative — no manual infrastructure changes
- All changes via PR → merge → FluxCD applies
- Self-hosted Forgejo + CI runners on Hetzner VPS
- Alerting pipeline from infrastructure to Telegram
- Documentation treated as infrastructure (MkDocs, Diátaxis)

---

### openclaw — Rumi, the Minecraft bot

**Role:** Architect and developer

A Minecraft bot built with [Mineflayer](https://github.com/PrismarineJS/mineflayer) and exposed as an MCP (Model Context Protocol) server, letting LLM agents perceive and act in the game world.

**What it does:**
- Autonomous Minecraft bot with pathfinding, building, and chat
- MCP server interface so LLM agents can call game actions as tools
- Lives in its own GitOps-managed repo with LXC services

**Tech stack:** Node.js, Mineflayer, MCP, TypeScript

**Highlights:**
- Bridges LLM agents and a live game world via a standard protocol
- A playground for agentic AI on real, stateful environments

---

*More projects coming soon.*