---
title: "Architecture"
date: 2026-08-09
draft: false
---

## Architecture

A high-level map of how the TekGarden platform connects on-prem infrastructure, cloud edge, and public access.

### Network Overview

{{< mermaid >}}
graph TB
    subgraph Internet["Internet"]
        USER["Users"]
    end

    subgraph Cloud["Cloud Edge — Hetzner VPS"]
        PANGOLIN["Pangolin<br/>Zero-trust tunnel gateway"]
        FORGEJO["Forgejo<br/>Self-hosted Git + CI runners"]
    end

    subgraph OnPrem["On-Prem — Homelab"]
        PFSENSE["pfSense Router<br/>VLANs + DNS + VPN"]
        PROXMOX["Proxmox VE Cluster<br/>2 nodes + QDevice"]
        K8S["Kubernetes (k3s)<br/>2 HA clusters<br/>prod + staging"]
        DOCKER["Docker Hosts<br/>3 nodes, 30+ services"]
        OBSERV["Observability<br/>Grafana + Prometheus<br/>+ Loki + Alertmanager"]
        SECRETS["Secrets<br/>1Password + SOPS/age<br/>+ Kyverno"]
    end

    subgraph External["External Services"]
        CF["Cloudflare<br/>DNS + CDN"]
        B2["Backblaze B2<br/>Off-site backups"]
        1PW["1Password<br/>Secrets vault"]
        TG["Telegram<br/>Alerts"]
    end

    USER -->|HTTPS| CF
    CF -->|Tunnel| PANGOLIN
    PANGOLIN -->|Zero-trust| PFSENSE
    PFSENSE --> PROXMOX
    PROXMOX --> K8S
    PROXMOX --> DOCKER
    K8S --> OBSERV
    K8S --> SECRETS
    DOCKER --> OBSERV
    SECRETS -.->|op inject| 1PW
    OBSERV -.->|alerts| TG
    PROXMOX -.->|PBS + B2| B2
    FORGEJO -.->|GitOps pull| K8S
    FORGEJO -.->|CI deploy| DOCKER
{{< /mermaid >}}

### Flow Description

1. **Public access** flows through Cloudflare → Pangolin (zero-trust tunnel gateway on the Hetzner VPS) → on-prem pfSense router.
2. **GitOps** runs from a self-hosted Forgejo on the Hetzner VPS — FluxCD pulls manifests into the Kubernetes clusters, and CI runners deploy Docker stacks to the standalone hosts.
3. **Proxmox VE** (2 nodes + QDevice for quorum) provides the virtualization layer running both Kubernetes clusters and Docker hosts.
4. **Kubernetes** runs two HA k3s clusters (production + staging, 12 nodes total).
5. **Docker** runs 30+ services across 3 standalone hosts.
6. **Observability** (Grafana + Prometheus + Loki + Alertmanager) monitors everything and sends alerts to Telegram.
7. **Secrets** are centralized in 1Password (injected via `op inject`), with SOPS/age for GitOps-encrypted manifests and Kyverno for runtime policies.
8. **Backups** go to Proxmox PBS locally and Backblaze B2 off-site.

### Tech Stack

| Layer | Technology |
|-------|-----------|
| Edge / Tunnel | Pangolin, Cloudflare, WireGuard |
| Git / CI | Forgejo, GitHub Actions runners |
| Virtualization | Proxmox VE (2 nodes + QDevice) |
| Orchestration | k3s (2 HA clusters), Docker Compose (3 hosts) |
| GitOps | FluxCD |
| Ingress | Traefik, cert-manager, Let's Encrypt, external-dns |
| Load Balancer | MetalLB |
| Observability | Grafana, Prometheus, Loki, Alertmanager |
| Secrets | 1Password, SOPS/age, Kyverno |
| IaC | OpenTofu, Ansible (pull mode) |
| Network | pfSense, VLANs, Pi-hole, Cloudflare DNS |
| Security | CrowdSec, Kyverno policies, NetworkPolicies |
| Backups | Proxmox PBS, Backblaze B2 |
| Storage | NVMe local, iSCSI NAS |