---
title: "Projects"
date: 2026-08-09
draft: false
---

## Projects

### TekGarden — Self-Managed Platform

**Role:** Architect and sole operator

A homelab-turned-production platform running on Proxmox with Kubernetes, GitOps, and full observability.

**What it does:**
- Hosts ~30 services across Docker and Kubernetes
- GitOps-driven deployments via FluxCD
- Full observability stack (Grafana, Prometheus, Loki)
- Automated alerting via Telegram
- Infrastructure as Code with Ansible and OpenTofu

**Tech stack:** k3s, FluxCD, Proxmox, Traefik, Grafana, Ansible, OpenTofu, Docker, Cloudflare

**Highlights:**
- Everything declarative — no manual infrastructure changes
- All changes via PR → merge → FluxCD applies
- Alerting pipeline from infrastructure to Telegram
- Documented infrastructure as infrastructure itself

---

*More projects coming soon.*