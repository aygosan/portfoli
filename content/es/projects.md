---
title: "Proyectos"
date: 2026-08-09
draft: false
---

## Proyectos

### TekGarden — Plataforma Auto-Gestionada

**Rol:** Arquitecto y único operador

Un homelab convertido en plataforma de producción funcionando sobre Proxmox con Kubernetes, GitOps y observabilidad completa.

**Qué hace:**
- Aloja ~30 servicios autoalojados entre Docker y Kubernetes
- Despliegues GitOps vía FluxCD
- Stack de observabilidad completa (Grafana, Prometheus, Loki)
- Alertas automatizadas vía Telegram
- Infraestructura como Código con Ansible y OpenTofu

**Tecnologías:** k3s, FluxCD, Proxmox, Traefik, Grafana, Ansible, OpenTofu, Cloudflare

**Destacados:**
- Todo declarativo — sin cambios manuales de infraestructura
- Todos los cambios vía PR → merge → FluxCD aplica
- Pipeline de alertas de infraestructura a Telegram
- Backups 3-2-1 y seguridad por defecto (CrowdSec, fail2ban, VLANs default-deny en OPNsense)

---

*Más proyectos próximamente.*