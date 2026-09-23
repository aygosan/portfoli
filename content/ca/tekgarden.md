---
title: "TekGarden"
date: 2026-08-09
draft: false
---

## TekGarden

TekGarden és la meva plataforma auto-gestionada — un homelab que ha evolucionat en una infraestructura de grau de producció funcionant 24/7. És on poso a prova, aprenc i opero tot el que faria en un entorn professional.

### Arquitectura

- **Proxmox VE** com a capa d'hipervisor (2 nodes amb qdevice)
- **Kubernetes (k3s)** — 2 clústers amb 6 nodes en total
- **FluxCD** per a GitOps — tots els desplegaments són declaratius i versionats
- **Traefik** com a controlador d'ingress amb TLS automàtic
- **NAS** per a emmagatzematge (iSCSI) i serveis de contenidors

### Pipeline GitOps

Cada canvi passa per Git:
1. Es crea un issue amb la descripció del canvi
2. Es crea una branca i un pull request
3. Revisió i merge
4. FluxCD detecta i aplica automàticament

### Observabilitat

- **Grafana** dashboards per a tots els serveis
- **Prometheus** recollida de mètriques
- **Loki** agregació de logs
- Alertes via bots de Telegram

### Infraestructura com a Codi

- **Ansible** (amb ansible-pull) per a gestió de configuració
- **OpenTofu** per a provisioning
- **GitHub Actions** self-hosted per a CI
- Tot versionat, sense canvis manuals

### Estadístiques

- ~30 serveis autoallotjats entre Docker i Kubernetes
- 2 clústers k3s (6 nodes)
- 99.9%+ objectiu d'uptime
- Tota la infraestructura declarativa