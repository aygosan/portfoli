---
title: "TekGarden"
date: 2026-08-09
draft: false
---

## TekGarden

TekGarden is my self-managed platform — a homelab that evolved into a production-grade infrastructure running 24/7. It's where I test, learn, and operate everything I would do in a professional setting.

### Architecture

- **Proxmox VE** as the hypervisor layer (4 nodes)
- **Kubernetes (k3s)** with 1 control plane + 3 workers
- **FluxCD** for GitOps — all deployments are declarative and version-controlled
- **Traefik** as the ingress controller with automatic TLS
- **QNAP NAS** for storage and Docker services

### GitOps Pipeline

Every change flows through Git:
1. Issue created with the change description
2. Branch and PR opened in the relevant repo
3. Review and merge
4. FluxCD detects and applies automatically

Repos: `fluxcd` (k8s manifests), `ansible` (configuration), `opentofu` (IaC), `docker` (images), `tekgarden` (docs)

### Observability

- **Grafana** dashboards for all services
- **Prometheus** metrics collection
- **Loki** log aggregation
- Alerting via Telegram bots

### Infrastructure as Code

- **Ansible** for configuration management
- **OpenTofu** for provisioning
- Everything version-controlled, no manual changes

### Stats

- ~30 Docker services running on QNAP
- 4 Kubernetes nodes
- 99.9%+ uptime goal
- All infrastructure declarative