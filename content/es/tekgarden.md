---
title: "TekGarden"
date: 2026-08-09
draft: false
---

## TekGarden

TekGarden es mi plataforma auto-gestionada — un homelab que evolucionó en una infraestructura de grado de producción funcionando 24/7. Es donde pruebo, aprendo y opero todo lo que haría en un entorno profesional.

### Arquitectura

- **Proxmox VE** como capa de hipervisor (4 nodos)
- **Kubernetes (k3s)** con 1 control plane + 3 workers
- **FluxCD** para GitOps — todos los despliegues son declarativos y versionados
- **Traefik** como controlador de ingress con TLS automático
- **QNAP NAS** para almacenamiento y servicios Docker

### Pipeline GitOps

Cada cambio fluye por Git:
1. Se crea un issue con la descripción del cambio
2. Se crea branch y PR en el repo correspondiente
3. Revisión y merge
4. FluxCD detecta y aplica automáticamente

Repos: `fluxcd` (manifests k8s), `ansible` (configuración), `opentofu` (IaC), `docker` (imágenes), `tekgarden` (docs)

### Observabilidad

- **Grafana** dashboards para todos los servicios
- **Prometheus** recolección de métricas
- **Loki** agregación de logs
- Alertas vía bots de Telegram

### Infraestructura como Código

- **Ansible** para gestión de configuración
- **OpenTofu** para provisioning
- Todo versionado, sin cambios manuales

### Estadísticas

- ~30 servicios Docker en QNAP
- 4 nodos de Kubernetes
- 99.9%+ objetivo de uptime
- Toda la infraestructura declarativa