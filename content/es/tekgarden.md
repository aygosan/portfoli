---
title: "TekGarden"
date: 2026-08-09
draft: false
---

## TekGarden

TekGarden es mi plataforma auto-gestionada — un homelab que evolucionó en una infraestructura de grado de producción funcionando 24/7. Es donde pruebo, aprendo y opero todo lo que haría en un entorno profesional.

### Arquitectura

- **Proxmox VE** como capa de hipervisor (2 nodos con qdevice)
- **Kubernetes (k3s)** — 2 clústeres con 6 nodos en total
- **FluxCD** para GitOps — todos los despliegues son declarativos y versionados
- **Traefik** como controlador de ingress con TLS automático
- **NAS** para almacenamiento (iSCSI) y servicios de contenedores

### Pipeline GitOps

Cada cambio fluye por Git:
1. Se crea un issue con la descripción del cambio
2. Se crea una rama y un pull request
3. Revisión y merge
4. FluxCD detecta y aplica automáticamente

### Observabilidad

- **Grafana** dashboards para todos los servicios
- **Prometheus** recolección de métricas
- **Loki** agregación de logs
- Alertas vía bots de Telegram

### Infraestructura como Código

- **Ansible** (con ansible-pull) para gestión de configuración
- **OpenTofu** para provisioning
- **GitHub Actions** self-hosted para CI
- Todo versionado, sin cambios manuales

### Estadísticas

- ~30 servicios autoalojados entre Docker y Kubernetes
- 2 clústeres k3s (6 nodos)
- 99.9%+ objetivo de uptime
- Toda la infraestructura declarativa