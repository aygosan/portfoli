---
title: "Arquitectura"
date: 2026-08-09
draft: false
---

## Arquitectura

Mapa a alt nivell de com la plataforma TekGarden connecta la infraestructura on-premise, l'edge cloud i l'accés públic.

### Visió de xarxa

{{< mermaid >}}
graph TB
    subgraph Internet["Internet"]
        USER["Usuaris"]
    end

    subgraph Cloud["Edge Cloud — VPS Hetzner"]
        PANGOLIN["Pangolin<br/>Gateway zero-trust"]
        FORGEJO["Forgejo<br/>Git self-hosted + runners CI"]
    end

    subgraph OnPrem["On-Prem — Homelab"]
        PFSENSE["Router pfSense<br/>VLANs + DNS + VPN"]
        PROXMOX["Clúster Proxmox VE<br/>2 nodes + QDevice"]
        K8S["Kubernetes (k3s)<br/>2 clústers HA<br/>prod + staging"]
        DOCKER["Hosts Docker<br/>3 nodes, 30+ serveis"]
        OBSERV["Observabilitat<br/>Grafana + Prometheus<br/>+ Loki + Alertmanager"]
        SECRETS["Secrets<br/>1Password + SOPS/age<br/>+ Kyverno"]
    end

    subgraph External["Serveis externs"]
        CF["Cloudflare<br/>DNS + CDN"]
        B2["Backblaze B2<br/>Backups off-site"]
        ONEPW["1Password<br/>Vault de secrets"]
        TG["Telegram<br/>Alertes"]
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
    OBSERV -.->|alertes| TG
    PROXMOX -.->|PBS + B2| B2
    FORGEJO -.->|GitOps pull| K8S
    FORGEJO -.->|CI deploy| DOCKER
{{< /mermaid >}}

### Descripció del flux

1. **Accés públic** flueix via Cloudflare → Pangolin (gateway de túnel zero-trust al VPS de Hetzner) → router pfSense on-premise.
2. **GitOps** s'executa des d'un Forgejo self-hosted al VPS de Hetzner — FluxCD fa pull dels manifests als clústers Kubernetes, i els runners de CI despleguen stacks Docker als hosts standalone.
3. **Proxmox VE** (2 nodes + QDevice per quòrum) proporciona la capa de virtualització que executa tant els clústers Kubernetes com els hosts Docker.
4. **Kubernetes** executa dos clústers HA de k3s (producció + staging, 12 nodes en total).
5. **Docker** executa 30+ serveis a 3 hosts standalone.
6. **Observabilitat** (Grafana + Prometheus + Loki + Alertmanager) monitoritza tot i envia alertes a Telegram.
7. **Secrets** estan centralitzats a 1Password (injectats via `op inject`), amb SOPS/age per a manifests xifrats a GitOps i Kyverno per a policies en runtime.
8. **Backups** van a Proxmox PBS en local i Backblaze B2 off-site.

### Stack tecnològic

| Capa | Tecnologia |
|------|-----------|
| Edge / Túnel | Pangolin, Cloudflare, WireGuard |
| Git / CI | Forgejo, runners de GitHub Actions |
| Virtualització | Proxmox VE (2 nodes + QDevice) |
| Orquestració | k3s (2 clústers HA), Docker Compose (3 hosts) |
| GitOps | FluxCD |
| Ingress | Traefik, cert-manager, Let's Encrypt, external-dns |
| Load Balancer | MetalLB |
| Observabilitat | Grafana, Prometheus, Loki, Alertmanager |
| Secrets | 1Password, SOPS/age, Kyverno |
| IaC | OpenTofu, Ansible (mode pull) |
| Xarxa | pfSense, VLANs, Pi-hole, Cloudflare DNS |
| Seguretat | CrowdSec, policies Kyverno, NetworkPolicies |
| Backups | Proxmox PBS, Backblaze B2 |
| Emmagatzematge | NVMe local, iSCSI NAS |