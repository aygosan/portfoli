---
title: "TekGarden"
date: 2026-08-09
draft: false
---

## TekGarden

TekGarden is my self-managed platform — a homelab that evolved into a production-grade infrastructure running 24/7. It's where I test, learn, and operate everything I would do in a professional setting.

### Architecture

- **Proxmox VE** cluster: 2 hypervisor nodes (`altair`, `draco`) + a QDevice for quorum
- **Kubernetes (k3s)** — two HA clusters:
  - **Vega** — production (3 control plane + 3 workers)
  - **Orion** — staging (3 control plane + 3 workers)
- **Docker** standalone on 3 nodes: `maggie` (20+ stacks), `edgeway`, `openclaw`
- **Forgejo VPS** on Hetzner Cloud — self-hosted Git with CI runners
- **Traefik** ingress controller with cert-manager + Let's Encrypt + external-dns
- **MetalLB** for bare-metal LoadBalancer services

### GitOps Pipeline

Every change flows through Git. Six independent repositories, each with its own remote and role:

| Repo | Role |
|------|------|
| `fluxcd` | Kubernetes manifests (FluxCD + Kustomize) |
| `ansible` | Configuration management (ansible-pull) |
| `opentofu` | Infrastructure provisioning (Proxmox, Hetzner, Cloudflare) |
| `docker` | Standalone Compose stacks |
| `tekgarden` | Docs (MkDocs Material, Diátaxis) |
| `openclaw` | Minecraft bot "Rumi" (Mineflayer + MCP) |

1. Issue → branch → PR in the relevant repo
2. Review and merge
3. FluxCD reconciles k8s every 1m; Ansible-pull runs every 15m via systemd timer; Docker CI deploys via self-hosted runners on each node

### Secrets

- **1Password** as the central vault (`op inject` + service accounts)
- **SOPS + age** for encrypted secrets committed to GitOps
- **Kyverno** policies to sync pull secrets and enforce governance
- **OnePasswordItem CRD** for runtime secrets in Kubernetes

### Observability

- **Grafana** dashboards for all services
- **Prometheus** metrics collection
- **Loki** log aggregation
- **Alertmanager** → Telegram alerts

### Infrastructure as Code

- **Ansible** for configuration (pull mode, idempotent, feature-flagged roles)
- **OpenTofu** for provisioning (LXC/VM lifecycle on Proxmox)
- Everything version-controlled — no manual infrastructure changes

### Network & Security

- **pfSense** router with segmented VLANs
- **Pi-hole** + Unbound for DNS filtering
- **Cloudflare** for public DNS and tunneling
- **CrowdSec** intrusion prevention
- **Kyverno** policies + Kubernetes NetworkPolicies
- **Proxmox PBS** + **Backblaze B2** for backups

### Beyond Infrastructure — openclaw

**Rumi** is a Minecraft bot built with Mineflayer and exposed as an MCP (Model Context Protocol) server, letting LLM agents interact with the game world. It lives in the `openclaw` repo alongside autonomous agents and LXC services.

### Stats

- 2 Proxmox nodes + QDevice
- 2 HA Kubernetes clusters (12 nodes total)
- 3 Docker hosts (30+ services)
- 6 GitOps repositories
- All infrastructure declarative and version-controlled