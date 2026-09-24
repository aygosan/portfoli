---
title: "Arquitectura"
date: 2026-08-09
draft: false
---

## Arquitectura

Mapa a alt nivell de com la plataforma TekGarden connecta la infraestructura on-premise, l'edge cloud i l'accés remot.

### Diagrama conceptual

Versió simplificada del flux complet: del repositori Git a l'observabilitat, passant per l'operador GitOps, Kubernetes i Docker, sobre la plataforma de virtualització (Proxmox).

![Arquitectura conceptual de TekGarden](/arquitectura-tekgarden.svg)

### Diagrama de xarxa

Topologia de xarxa d'exemple: VLANs separades per gestió, usuaris, serveis i IoT, amb tronc VLAN cap al switch L3 i segmentació dels serveis per limitar el moviment lateral.

![Topologia de xarxa d'exemple](/xarxa-exemple.svg)

### Visió de xarxa

{{< mermaid >}}

flowchart TB
    classDef ext fill:#1f2937,stroke:#9ca3af,color:#f9fafb,stroke-width:1px
    classDef edge fill:#0f172a,stroke:#38bdf8,color:#e0f2fe,stroke-width:1px
    classDef fw fill:#3b1d1d,stroke:#f87171,color:#fee2e2,stroke-width:1px
    classDef onprem fill:#0f2a1d,stroke:#4ade80,color:#dcfce7,stroke-width:1px
    classDef sec fill:#2a1f0f,stroke:#fbbf24,color:#fef3c7,stroke-width:1px
    classDef off fill:#1f1f1f,stroke:#6b7280,color:#d1d5db,stroke-width:1px,stroke-dasharray:4 3

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

    class USER,REMOTE ext
    class CF,PANGOLIN,FORGEJO edge
    class PFSENSE fw
    class PROXMOX,K8S,QNAP,TRAEFIK_K,TRAEFIK_Q,PBS onprem
    class B2,ONEPW,TG sec
    class EXTDISK off
{{< /mermaid >}}

### Descripció del flux

1. **Accés públic** flueix via Cloudflare → Pangolin (gateway de túnel zero-trust al VPS de Hetzner) → router pfSense. pfSense només permet tràfic a DNS, al Traefik del QNAP (ingress Docker) i al Traefik de k3s (ingress Kubernetes): tots protegits amb agents CrowdSec.
2. **Accés remot**: un WireGuard road warrior VPN al pfSense permet connectar portàtils i mòbil des de qualsevol lloc. Un cop connectat, tens accés a tota la xarxa del TekGarden i a la xarxa privada de Hetzner (inclòs Forgejo), com si fossis a casa.
3. **Forgejo** funciona a una xarxa privada de Hetzner: només accessible internament des del TekGarden. Si cal accés extern, Pangolin el pot exposar sota demanda.
4. **GitOps** s'executa des de Forgejo: FluxCD fa pull dels manifests als clústers Kubernetes, i els runners de CI despleguen stacks Docker al QNAP i altres hosts Docker.
5. **Proxmox VE** (2 nodes + QDevice per quòrum) proporciona la capa de virtualització que executa tant els clústers Kubernetes com els hosts Docker.
6. **Kubernetes** executa dos clústers HA de k3s (producció + staging, 12 nodes en total).
7. **Docker** executa 30+ serveis a 3 hosts standalone, incloent el QNAP NAS.
8. **Backups** segueixen una estratègia de 3 nivells:
   - **Proxmox PBS**: còpies locals dels guests de Proxmox, després sincronitzades a Backblaze B2.
   - **Backrest** (Docker al QNAP): còpies locals de les dades Docker, després enviades a B2.
   - **Còpia offline**: backup setmanal a un disc extern.
9. **Observabilitat** (Grafana + Prometheus + Loki + Alertmanager) monitoritza tot i envia alertes a Telegram.
10. **Secrets** estan centralitzats a 1Password (injectats via `op inject`), amb SOPS/age per a manifests xifrats a GitOps i Kyverno per a policies en runtime.

### Stack tecnològic

| Capa | Tecnologia |
|------|-----------|
| Edge / Túnel | Pangolin, Cloudflare |
| VPN | WireGuard (road warrior al pfSense) |
| Git / CI | Forgejo (xarxa privada Hetzner) |
| Virtualització | Proxmox VE (2 nodes + QDevice) |
| Orquestració | k3s (2 clústers HA), Docker Compose (3 hosts) |
| GitOps | FluxCD |
| Ingress | Traefik (k3s + Docker), cert-manager, Let's Encrypt, external-dns |
| Load Balancer | MetalLB |
| Observabilitat | Grafana, Prometheus, Loki, Alertmanager |
| Secrets | 1Password, SOPS/age, Kyverno |
| IaC | OpenTofu, Ansible (mode pull) |
| Xarxa | pfSense, VLANs, Pi-hole, Cloudflare DNS |
| Seguretat | CrowdSec (a tots els Traefik), policies Kyverno, NetworkPolicies |
| Backups | Proxmox PBS → B2, Backrest (QNAP) → B2, disc offline setmanal |
| Emmagatzematge | NVMe local, iSCSI QNAP |