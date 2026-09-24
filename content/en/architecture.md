---
title: "Architecture"
date: 2026-08-09
draft: false
---

## Architecture

A high-level map of how the TekGarden platform connects on-prem infrastructure, the cloud edge, and remote access.

### Conceptual Diagram

A simplified view of the full flow: from the Git repository to observability, through the GitOps operator, Kubernetes and Docker, on top of the virtualization platform (Proxmox).

![TekGarden conceptual architecture](/arquitectura-tekgarden.svg)

### Network Diagram

Sample network topology: VLANs separated for management, users, services and IoT, with a VLAN trunk to the L3 switch and service segmentation to limit lateral movement.

![Sample network topology](/xarxa-exemple.svg)

### Network Overview

{{< mermaid >}}
flowchart TB

    subgraph Internet["Internet"]
        USER["Usuaris<br/>navegador"]
        REMOTE["Portàtils / mòbil<br/>WireGuard road warrior"]
    end

    subgraph Edge["Edge Cloud · VPS Hetzner"]
        CF["Cloudflare<br/>DNS + CDN + WAF"]
        PANGOLIN["Pangolin<br/>gateway zero-trust"]
        FORGEJO["Forgejo<br/>Git + CI<br/>xarxa privada"]
    end

    subgraph OnPrem["On-Prem · Homelab"]
        PFSENSE["Router pfSense<br/>firewall + WireGuard<br/>només: DNS, Traefik QNAP, Traefik k3s"]
        PROXMOX["Proxmox VE<br/>2 nodes + QDevice"]
        K8S["k3s<br/>2 clústers HA<br/>prod + staging"]
        QNAP["QNAP NAS<br/>Docker + Backrest"]
        TRAEFIK_K["Traefik k3s<br/>+ CrowdSec"]
        TRAEFIK_Q["Traefik QNAP<br/>+ CrowdSec"]
        PBS["Proxmox PBS<br/>backups locals"]
    end

    subgraph Ext["Serveis externs"]
        B2["Backblaze B2<br/>off-site"]
        ONEPW["1Password<br/>vault de secrets"]
        TG["Telegram<br/>alertes"]
    end

    subgraph Off["Offline"]
        EXTDISK["Disc extern<br/>còpia setmanal"]
    end

    CF -->|túnel| PANGOLIN
    USER -->|HTTPS| CF
    PANGOLIN -->|zero-trust| PFSENSE

    PFSENSE -->|ingress| TRAEFIK_Q
    PFSENSE -->|ingress| TRAEFIK_K
    TRAEFIK_Q --> QNAP
    TRAEFIK_K --> K8S

    REMOTE -.->|VPN WireGuard| PFSENSE
    PFSENSE -.->|xarxa privada| FORGEJO
    PANGOLIN -.->|accés extern opcional| FORGEJO

    FORGEJO -.->|GitOps pull| K8S
    FORGEJO -.->|CI deploy| QNAP

    PROXMOX --> K8S
    PROXMOX --> QNAP
    PBS -.->|backup local| PROXMOX
    PBS -.->|sync| B2
    QNAP -.->|Backrest local| QNAP
    QNAP -.->|Backrest| B2
    QNAP -.->|setmanal| EXTDISK

    K8S -.->|op inject| ONEPW
    K8S -.->|alertes| TG
{{< /mermaid >}}

### Flow Description

1. **Public access** flows through Cloudflare → Pangolin (zero-trust tunnel gateway on the Hetzner VPS) → pfSense router. pfSense only allows traffic to DNS, the QNAP Traefik (Docker ingress), and the k3s Traefik (Kubernetes ingress): all protected by CrowdSec agents.
2. **Remote access**: a WireGuard road warrior VPN on pfSense lets laptops and mobile connect from anywhere. Once connected, you have access to the entire TekGarden network and the Hetzner private network (including Forgejo), as if you were at home.
3. **Forgejo** runs on a Hetzner private network: only reachable internally from TekGarden. If external access is needed, Pangolin can expose it on demand.
4. **GitOps** runs from Forgejo: FluxCD pulls manifests into the Kubernetes clusters, and CI runners deploy Docker stacks to the QNAP and other Docker hosts.
5. **Proxmox VE** (2 nodes + QDevice for quorum) provides the virtualization layer running both Kubernetes clusters and Docker hosts.
6. **Kubernetes** runs two HA k3s clusters (production + staging, 12 nodes total).
7. **Docker** runs 30+ services across 3 standalone hosts, including the QNAP NAS.
8. **Backups** follow a 3-tier strategy:
   - **Proxmox PBS**: local backups of Proxmox guests, then synced to Backblaze B2.
   - **Backrest** (Docker on the QNAP): local backups of Docker data, then sent to B2.
   - **Offline copy**: weekly backup to an external disk.
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