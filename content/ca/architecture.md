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

![Visió de xarxa: flux d'accés zero-trust (Cloudflare, Pangolin, pfSense, Traefik)](/visio-xarxa-flux.svg)

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