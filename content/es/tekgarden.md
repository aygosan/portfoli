---
title: "TekGarden"
date: 2026-08-09
draft: false
---

## TekGarden

TekGarden es mi plataforma auto-gestionada — un homelab que evolucionó en una infraestructura de grado de producción funcionando 24/7. Es donde pruebo, aprendo y opero todo lo que haría en un entorno profesional.

### Arquitectura

- **Proxmox VE** en clúster: 2 nodos de hipervisor (`altair`, `draco`) + un QDevice para quórum
- **Kubernetes (k3s)** — dos clústeres HA:
  - **Vega** — producción (3 control plane + 3 workers)
  - **Orion** — staging (3 control plane + 3 workers)
- **Docker** standalone en 3 nodos: `maggie` (20+ stacks), `edgeway`, `openclaw`
- **Forgejo VPS** en Hetzner Cloud — Git self-hosted con runners de CI
- **Traefik** como controlador de ingress con cert-manager + Let's Encrypt + external-dns
- **MetalLB** para servicios LoadBalancer bare-metal

### Pipeline GitOps

Cada cambio fluye por Git. Seis repositorios independientes, cada uno con su propio remoto y rol:

| Repo | Rol |
|------|-----|
| `fluxcd` | Manifiestos de Kubernetes (FluxCD + Kustomize) |
| `ansible` | Gestión de configuración (ansible-pull) |
| `opentofu` | Provisioning de infraestructura (Proxmox, Hetzner, Cloudflare) |
| `docker` | Stacks Compose standalone |
| `tekgarden` | Documentación (MkDocs Material, Diátaxis) |
| `openclaw` | Bot de Minecraft "Rumi" (Mineflayer + MCP) |

1. Issue → branch → PR en el repo correspondiente
2. Revisión y merge
3. FluxCD reconcilia k8s cada 1m; ansible-pull se ejecuta cada 15m vía timer de systemd; el CI de Docker despliega vía runners self-hosted en cada nodo

### Secrets

- **1Password** como vault central (`op inject` + service accounts)
- **SOPS + age** para secretos cifrados commiteados a GitOps
- **Kyverno** policies para sincronizar pull secrets y aplicar gobernanza
- **OnePasswordItem CRD** para secretos en runtime en Kubernetes

### Observabilidad

- **Grafana** dashboards para todos los servicios
- **Prometheus** recolección de métricas
- **Loki** agregación de logs
- **Alertmanager** → alertas a Telegram

### Infraestructura como Código

- **Ansible** para configuración (modo pull, idempotente, roles con feature flags)
- **OpenTofu** para provisioning (ciclo de vida de LXC/VM en Proxmox)
- Todo versionado — sin cambios manuales de infraestructura

### Red y Seguridad

- **pfSense** router con VLANs segmentadas
- **Pi-hole** + Unbound para filtrado DNS
- **Cloudflare** para DNS público y tunelización
- **CrowdSec** prevención de intrusión
- **Kyverno** policies + NetworkPolicies de Kubernetes
- **Proxmox PBS** + **Backblaze B2** para backups

### Más allá de la infraestructura — openclaw

**Rumi** es un bot de Minecraft construido con Mineflayer y expuesto como servidor MCP (Model Context Protocol), permitiendo que agentes LLM interactúen con el mundo del juego. Vive en el repo `openclaw` junto con agentes autónomos y servicios LXC.

### Estadísticas

- 2 nodos Proxmox + QDevice
- 2 clústeres HA de Kubernetes (12 nodos en total)
- 3 hosts Docker (30+ servicios)
- 6 repositorios GitOps
- Toda la infraestructura declarativa y versionada