---
title: "TekGarden"
date: 2026-08-09
draft: false
---

## TekGarden

TekGarden és la meva plataforma auto-gestionada — un homelab que ha evolucionat en una infraestructura de grau de producció funcionant 24/7. És on poso a prova, aprenc i opero tot el que faria en un entorn professional.

### Arquitectura

- **Proxmox VE** en clúster: 2 nodes d'hipervisor (`altair`, `draco`) + un QDevice per a quòrum
- **Kubernetes (k3s)** — dos clústers HA:
  - **Vega** — producció (3 control plane + 3 workers)
  - **Orion** — staging (3 control plane + 3 workers)
- **Docker** standalone en 3 nodes: `maggie` (20+ stacks), `edgeway`, `openclaw`
- **Forgejo VPS** a Hetzner Cloud — Git self-hosted amb runners de CI
- **Traefik** com a controlador d'ingress amb cert-manager + Let's Encrypt + external-dns
- **MetalLB** per a serveis LoadBalancer bare-metal

### Pipeline GitOps

Cada canvi passa per Git. Sis repositoris independents, cadascun amb el seu propi remot i rol:

| Repo | Rol |
|------|-----|
| `fluxcd` | Manifests de Kubernetes (FluxCD + Kustomize) |
| `ansible` | Gestió de configuració (ansible-pull) |
| `opentofu` | Provisioning d'infraestructura (Proxmox, Hetzner, Cloudflare) |
| `docker` | Stacks Compose standalone |
| `tekgarden` | Documentació (MkDocs Material, Diátaxis) |
| `openclaw` | Bot de Minecraft "Rumi" (Mineflayer + MCP) |

1. Issue → branca → PR al repo corresponent
2. Revisió i merge
3. FluxCD reconcilia k8s cada 1m; ansible-pull s'executa cada 15m via timer de systemd; el CI de Docker desplega via runners self-hosted a cada node

### Secrets

- **1Password** com a vault central (`op inject` + service accounts)
- **SOPS + age** per a secrets xifrats committed a GitOps
- **Kyverno** policies per sincronitzar pull secrets i aplicar governança
- **OnePasswordItem CRD** per a secrets en runtime a Kubernetes

### Observabilitat

- **Grafana** dashboards per a tots els serveis
- **Prometheus** recollida de mètriques
- **Loki** agregació de logs
- **Alertmanager** → alertes a Telegram

### Infraestructura com a Codi

- **Ansible** per a configuració (mode pull, idempotent, rols amb feature flags)
- **OpenTofu** per a provisioning (cicle de vida de LXC/VM a Proxmox)
- Tot versionat — sense canvis manuals d'infraestructura

### Xarxa i Seguretat

- **pfSense** router amb VLANs segmentades
- **Pi-hole** + Unbound per a filtratge DNS
- **Cloudflare** per a DNS públic i tunelització
- **CrowdSec** prevenció d'intrusió
- **Kyverno** policies + NetworkPolicies de Kubernetes
- **Proxmox PBS** + **Backblaze B2** per a backups

### Més enllà de la infraestructura — openclaw

**Rumi** és un bot de Minecraft construït amb Mineflayer i exposat com a servidor MCP (Model Context Protocol), permetent que agents LLM interactuïn amb el món del joc. Viu al repo `openclaw` juntament amb agents autònoms i serveis LXC.

### Estadístiques

- 2 nodes Proxmox + QDevice
- 2 clústers HA de Kubernetes (12 nodes en total)
- 3 hosts Docker (30+ serveis)
- 6 repositoris GitOps
- Tota la infraestructura declarativa i versionada