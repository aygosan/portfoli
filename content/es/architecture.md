---
title: "Arquitectura"
date: 2026-08-09
draft: false
---

## Arquitectura

Mapa de alto nivel de cómo la plataforma TekGarden conecta la infraestructura on-premise, el edge cloud y el acceso público.

### Visión de red

{{< mermaid >}}
graph TB
    subgraph Internet["Internet"]
        USER["Usuarios"]
    end

    subgraph Cloud["Edge Cloud — VPS Hetzner"]
        PANGOLIN["Pangolin<br/>Gateway zero-trust"]
        FORGEJO["Forgejo<br/>Git self-hosted + runners CI"]
    end

    subgraph OnPrem["On-Prem — Homelab"]
        PFSENSE["Router pfSense<br/>VLANs + DNS + VPN"]
        PROXMOX["Clúster Proxmox VE<br/>2 nodos + QDevice"]
        K8S["Kubernetes (k3s)<br/>2 clústeres HA<br/>prod + staging"]
        DOCKER["Hosts Docker<br/>3 nodos, 30+ servicios"]
        OBSERV["Observabilidad<br/>Grafana + Prometheus<br/>+ Loki + Alertmanager"]
        SECRETS["Secretos<br/>1Password + SOPS/age<br/>+ Kyverno"]
    end

    subgraph External["Servicios externos"]
        CF["Cloudflare<br/>DNS + CDN"]
        B2["Backblaze B2<br/>Backups off-site"]
        ONEPW["1Password<br/>Vault de secretos"]
        TG["Telegram<br/>Alertas"]
    end

    USER -->|HTTPS| CF
    CF -->|Túnel| PANGOLIN
    PANGOLIN -->|Zero-trust| PFSENSE
    PFSENSE --> PROXMOX
    PROXMOX --> K8S
    PROXMOX --> DOCKER
    K8S --> OBSERV
    K8S --> SECRETS
    DOCKER --> OBSERV
    SECRETS -.->|op inject| ONEPW
    OBSERV -.->|alertas| TG
    PROXMOX -.->|PBS + B2| B2
    FORGEJO -.->|GitOps pull| K8S
    FORGEJO -.->|CI deploy| DOCKER
{{< /mermaid >}}

### Descripción del flujo

1. **Acceso público** fluye vía Cloudflare → Pangolin (gateway de túnel zero-trust en el VPS de Hetzner) → router pfSense on-premise.
2. **GitOps** se ejecuta desde un Forgejo self-hosted en el VPS de Hetzner — FluxCD hace pull de los manifiestos a los clústeres Kubernetes, y los runners de CI despliegan stacks Docker a los hosts standalone.
3. **Proxmox VE** (2 nodos + QDevice para quórum) proporciona la capa de virtualización que ejecuta tanto los clústeres Kubernetes como los hosts Docker.
4. **Kubernetes** ejecuta dos clústeres HA de k3s (producción + staging, 12 nodos en total).
5. **Docker** ejecuta 30+ servicios en 3 hosts standalone.
6. **Observabilidad** (Grafana + Prometheus + Loki + Alertmanager) monitorea todo y envía alertas a Telegram.
7. **Secretos** están centralizados en 1Password (inyectados vía `op inject`), con SOPS/age para manifiestos cifrados en GitOps y Kyverno para políticas en runtime.
8. **Backups** van a Proxmox PBS en local y Backblaze B2 off-site.

### Stack tecnológico

| Capa | Tecnología |
|------|-----------|
| Edge / Túnel | Pangolin, Cloudflare, WireGuard |
| Git / CI | Forgejo, runners de GitHub Actions |
| Virtualización | Proxmox VE (2 nodos + QDevice) |
| Orquestación | k3s (2 clústeres HA), Docker Compose (3 hosts) |
| GitOps | FluxCD |
| Ingress | Traefik, cert-manager, Let's Encrypt, external-dns |
| Load Balancer | MetalLB |
| Observabilidad | Grafana, Prometheus, Loki, Alertmanager |
| Secretos | 1Password, SOPS/age, Kyverno |
| IaC | OpenTofu, Ansible (modo pull) |
| Red | pfSense, VLANs, Pi-hole, Cloudflare DNS |
| Seguridad | CrowdSec, políticas Kyverno, NetworkPolicies |
| Backups | Proxmox PBS, Backblaze B2 |
| Almacenamiento | NVMe local, iSCSI NAS |