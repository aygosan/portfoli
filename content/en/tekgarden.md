---
title: "TekGarden"
date: 2026-08-09
draft: false
---

## TekGarden

TekGarden is my self-managed platform — a homelab that evolved into a production-grade infrastructure running 24/7. It's where I test, learn, and operate everything I would do in a professional setting.

### Architecture

- **Proxmox VE** as the hypervisor layer (2 nodes with qdevice)
- **Kubernetes (k3s)** — 2 clusters with 6 nodes in total
- **FluxCD** for GitOps — all deployments are declarative and version-controlled
- **Traefik** as the ingress controller with automatic TLS
- **NAS** for storage (iSCSI) and container services

### GitOps Pipeline

Every change flows through Git:
1. Issue created with the change description
2. Branch and pull request opened
3. Review and merge
4. FluxCD detects and applies automatically

### Observability

- **Grafana** dashboards for all services
- **Prometheus** metrics collection
- **Loki** log aggregation
- Alerting via Telegram bots

### Infrastructure as Code

- **Ansible** (with ansible-pull) for configuration management
- **OpenTofu** for provisioning
- **GitHub Actions** self-hosted runners for CI
- Everything version-controlled, no manual changes

### Stats

- ~30 self-hosted services across Docker and Kubernetes
- 2 k3s clusters (6 nodes)
- 99.9%+ uptime goal
- All infrastructure declarative