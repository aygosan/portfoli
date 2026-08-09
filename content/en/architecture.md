---
title: "Architecture"
date: 2026-08-09
draft: false
---

## Architecture

A high-level map of how the TekGarden platform connects on-prem infrastructure, the cloud edge, and remote access.

### Network Overview

{{< mermaid >}}
graph TB
    subgraph Internet["Internet"]
        USER["Users"]
        REMOTE["Laptops / Mobile<br/>WireGuard road warrior"]
    end

    subgraph Cloud["Cloud Edge — Hetzner VPS"]
        PANGOLIN["Pangolin<br/>Zero-trust tunnel gateway"]
        FORGEJO["Forgejo<br/>Self-hosted Git + CI<br/>private network only"]
    end

    subgraph OnPrem["On-Prem — Homelab"]
        PFSENSE["pfSense Router<br/>Firewall rules + WireGuard road warrior<br/>Only open: DNS, Traefik QNAP, Traefik k3s"]
        PROXMOX["Proxmox VE Cluster<br/>2 nodes + QDevice"]
        K8S["Kubernetes (k3s)<br/>2 HA clusters<br/>prod + staging"]
        QNAP["QNAP NAS<br/>Docker + Backrest backups<br/>+ Traefik (Docker ingress)"]
        PBS["Proxmox PBS<br/>Local backups → B2 sync"]
        SECRETS["Secrets<br/>1Password + SOPS/age<br/>+ Kyverno"]
    end

    subgraph External["External Services"]
        CF["Cloudflare<br/>DNS + CDN"]
        B2["Backblaze B2<br/>Off-site backups"]
        ONEPW["1Password<br/>Secrets vault"]
        TG["Telegram<br/>Alerts"]
    end

    subgraph Offline["Offline"]
        EXTDISK["External disk<br/>Weekly offline copy"]
    end

    USER -->|HTTPS| CF
    CF -->|Tunnel| PANGOLIN
    PANGOLIN -->|Zero-trust| PFSENSE
    PFSENSE -->|DNS + Traefik only| QNAP
    PFSENSE -->|DNS + Traefik only| K8S
    PFSENSE --> PROXMOX
    PROXMOX --> K8S
    PROXMOX --> QNAP

    REMOTE -.->|WireGuard VPN| PFSENSE
    PFSENSE -.->|private network| FORGEJO
    PANGOLIN -.->|optional external access| FORGEJO

    FORGEJO -.->|GitOps pull| K8S
    FORGEJO -.->|CI deploy| QNAP

    PBS -.->|local backup| PROXMOX
    PBS -.->|sync| B2
    QNAP -.->|Backrest local| QNAP
    QNAP -.->|Backrest → B2| B2
    QNAP -.->|weekly| EXTDISK

    K8S --> SECRETS
    SECRETS -.->|op inject| ONEPW
    K8S -.->|alerts| TG
{{< /mermaid >}}

### Flow Description

1. **Public access** flows through Cloudflare → Pangolin (zero-trust tunnel gateway on the Hetzner VPS) → pfSense router. pfSense only allows traffic to DNS, the QNAP Traefik (Docker ingress), and the k3s Traefik (Kubernetes ingress) — all protected by CrowdSec agents.
2. **Remote access** — a WireGuard road warrior VPN on pfSense lets laptops and mobile connect from anywhere. Once connected, you have access to the entire TekGarden network and the Hetzner private network (including Forgejo), as if you were at home.
3. **Forgejo** runs on a Hetzner private network — only reachable internally from TekGarden. If external access is needed, Pangolin can expose it on demand.
4. **GitOps** runs from Forgejo — FluxCD pulls manifests into the Kubernetes clusters, and CI runners deploy Docker stacks to the QNAP and other Docker hosts.
5. **Proxmox VE** (2 nodes + QDevice for quorum) provides the virtualization layer running both Kubernetes clusters and Docker hosts.
6. **Kubernetes** runs two HA k3s clusters (production + staging, 12 nodes total).
7. **Docker** runs 30+ services across 3 standalone hosts, including the QNAP NAS.
8. **Backups** follow a 3-tier strategy:
   - **Proxmox PBS** — local backups of Proxmox guests, then synced to Backblaze B2.
   - **Backrest** (Docker on the QNAP) — local backups of Docker data, then sent to B2.
   - **Offline copy** — weekly backup to an external disk.
9. **Observability** (Grafana + Prometheus + Loki + Alertmanager) monitors everything and sends alerts to Telegram.
10. **Secrets** are centralized in 1Password (injected via `op inject`), with SOPS/age for GitOps-encrypted manifests and Kyverno for runtime policies.

### Tech Stack

| Layer | Technology |
|-------|-----------|
| Edge / Tunnel | Pangolin, Cloudflare |
| VPN | WireGuard (road warrior on pfSense) |
| Git / CI | Forgejo (Hetzner private network) |
| Virtualization | Proxmox VE (2 nodes + QDevice) |
| Orchestration | k3s (2 HA clusters), Docker Compose (3 hosts) |
| GitOps | FluxCD |
| Ingress | Traefik (k3s + Docker), cert-manager, Let's Encrypt, external-dns |
| Load Balancer | MetalLB |
| Observability | Grafana, Prometheus, Loki, Alertmanager |
| Secrets | 1Password, SOPS/age, Kyverno |
| IaC | OpenTofu, Ansible (pull mode) |
| Network | pfSense, VLANs, Pi-hole, Cloudflare DNS |
| Security | CrowdSec (on all Traefik instances), Kyverno policies, NetworkPolicies |
| Backups | Proxmox PBS → B2, Backrest (QNAP) → B2, weekly offline disk |
| Storage | NVMe local, iSCSI QNAP |