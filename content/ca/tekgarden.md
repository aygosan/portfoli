---
title: "TekGarden"
date: 2026-08-09
draft: false
---

## TekGarden

TekGarden és la meva plataforma auto-gestionada — un homelab que ha evolucionat en una infraestructura de grau de producció funcionant 24/7. És on poso a prova, aprenc i opero tot el que faria en un entorn professional.

### Arquitectura

- **Proxmox VE** com a capa d'hipervisor (4 nodes)
- **Kubernetes (k3s)** amb 1 control plane + 3 workers
- **FluxCD** per a GitOps — tots els desplegaments són declaratius i versionats
- **Traefik** com a controlador d'ingress amb TLS automàtic
- **QNAP NAS** per a emmagatzematge i serveis Docker

### Pipeline GitOps

Cada canvi passa per Git:
1. Es crea un issue amb la descripció del canvi
2. Es crea branca i PR al repo corresponent
3. Revisió i merge
4. FluxCD detecta i aplica automàticament

Repos: `fluxcd` (manifests k8s), `ansible` (configuració), `opentofu` (IaC), `docker` (imatges), `tekgarden` (docs)

### Observabilitat

- **Grafana** dashboards per a tots els serveis
- **Prometheus** recollida de mètriques
- **Loki** agregació de logs
- Alertes via bots de Telegram

### Infraestructura com a Codi

- **Ansible** per a gestió de configuració
- **OpenTofu** per a provisioning
- Tot versionat, sense canvis manuals

### Estadístiques

- ~30 serveis Docker al QNAP
- 4 nodes de Kubernetes
- 99.9%+ objectiu d'uptime
- Tota la infraestructura declarativa