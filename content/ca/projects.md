---
title: "Projectes"
date: 2026-08-09
draft: false
---

## Projectes

### TekGarden — Plataforma Auto-Gestionada

**Rol:** Arquitecte i únic operador

Un homelab convertit en plataforma de producció funcionant sobre Proxmox amb Kubernetes, GitOps i observabilitat completa.

**Què fa:**
- Allotja ~30 serveis autoallotjats entre Docker i Kubernetes
- Desplegaments GitOps via FluxCD
- Stack d'observabilitat completa (Grafana, Prometheus, Loki)
- Alertes automatitzades via Telegram
- Infraestructura com a Codi amb Ansible i OpenTofu

**Tecnologies:** k3s, FluxCD, Proxmox, Traefik, Grafana, Ansible, OpenTofu, Cloudflare

**Destacats:**
- Tot declaratiu — sense canvis manuals d'infraestructura
- Tots els canvis via PR → merge → FluxCD aplica
- Pipeline d'alertes d'infraestructura a Telegram
- Backups 3-2-1 i seguretat per defecte (CrowdSec, fail2ban, VLANs default-deny a OPNsense)

---

*More projectes coming soon.*