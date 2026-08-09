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
- Aloja ~30 servicios entre Docker y Kubernetes
- Despliegues GitOps vía FluxCD
- Stack de observabilidad completa (Grafana, Prometheus, Loki)
- Alertas automatizadas vía Telegram
- Infraestructura como Código con Ansible y OpenTofu

**Tecnologías:** k3s, FluxCD, Proxmox, Traefik, Grafana, Ansible, OpenTofu, Docker, Cloudflare

**Destacados:**
- Todo declarativo — sin cambios manuales de infraestructura
- Todos los cambios vía PR → merge → FluxCD aplica
- Pipeline de alertas de infraestructura a Telegram
- Infraestructura documentada como infraestructura

---

*More proyectos coming soon.*