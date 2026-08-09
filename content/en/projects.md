---
title: "Projects"
date: 2026-08-09
draft: false
---

## Projects

### TekGarden — Self-Managed Platform

**Role:** Architect and sole operator

A homelab evolved into a production-grade platform running 24/7 on Proxmox with Kubernetes, GitOps, and full observability.

**What it does:**
- 2 HA Kubernetes clusters (production + staging) — 12 nodes total
- 3 Docker hosts running 30+ services
- GitOps deployments via FluxCD (6 repos, reconciles every 1m)
- Full observability stack (Grafana, Prometheus, Loki, Alertmanager → Telegram)
- Infrastructure as Code with Ansible (pull mode) and OpenTofu
- Secrets via 1Password + SOPS/age + Kyverno policies
- Backups to Proxmox PBS + Backblaze B2
- Self-hosted Forgejo + CI runners on a Hetzner VPS

**Tech stack:** k3s, FluxCD, Proxmox VE, Traefik, cert-manager, MetalLB, Grafana, Ansible, OpenTofu, Docker, 1Password, Kyverno, CrowdSec, pfSense, Cloudflare

**Highlights:**
- Everything declarative — no manual infrastructure changes
- All changes via PR → merge → FluxCD applies
- Alerting pipeline from infrastructure to Telegram
- Documentation treated as infrastructure (MkDocs, Diátaxis)

---

### Minecraft bot — autonomous in-game agent

**Role:** Architect and developer

An autonomous Minecraft bot that connects directly to the game server via a plugin, able to interact with the world in real time. It bridges LLM agents and a live, stateful game environment through a standard protocol.

**What it does:**
- Autonomous in-game actions: pathfinding, building, chat
- Exposed as an MCP (Model Context Protocol) server so LLM agents can call game actions as tools
- Runs on GitOps-managed infrastructure

**Tech stack:** Node.js, Mineflayer, MCP, TypeScript

**Highlights:**
- Bridges LLM agents and a live game world via a standard protocol
- A playground for agentic AI on real, stateful environments

---

*More projects coming soon.*