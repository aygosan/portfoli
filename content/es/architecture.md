---
title: "Arquitectura"
date: 2026-08-09
draft: false
---

## Arquitectura

Mapa de alto nivel de cómo la plataforma TekGarden conecta la infraestructura on-premise, el edge cloud y el acceso remoto.

### Diagrama conceptual

Versión simplificada del flujo completo: del repositorio Git a la observabilidad, pasando por el operador GitOps, Kubernetes y Docker, sobre la plataforma de virtualización (Proxmox).

![Arquitectura conceptual de TekGarden](/arquitectura-tekgarden.svg)

### Diagrama de red

Topología de red de ejemplo: VLANs separadas para gestión, usuarios, servicios e IoT, con tronco VLAN hacia el switch L3 y segmentación de servicios para limitar el movimiento lateral.

![Topología de red de ejemplo](/xarxa-exemple.svg)

### Visión de red

![Visión de red: flujo de acceso zero-trust (Cloudflare, Pangolin, pfSense, Traefik)](/visio-xarxa-flux.svg)

### Descripción del flujo

1. **Acceso público** fluye vía Cloudflare → Pangolin (gateway de túnel zero-trust en el VPS de Hetzner) → router pfSense. pfSense solo permite tráfico a DNS, al Traefik del QNAP (ingress Docker) y al Traefik de k3s (ingress Kubernetes): todos protegidos con agentes CrowdSec.
2. **Acceso remoto**: un WireGuard road warrior VPN en pfSense permite conectar portátiles y móvil desde cualquier lugar. Una vez conectado, tienes acceso a toda la red de TekGarden y a la red privada de Hetzner (incluido Forgejo), como si estuvieras en casa.
3. **Forgejo** funciona en una red privada de Hetzner: solo accesible internamente desde TekGarden. Si se necesita acceso externo, Pangolin puede exponerlo bajo demanda.
4. **GitOps** se ejecuta desde Forgejo: FluxCD hace pull de los manifiestos a los clústeres Kubernetes, y los runners de CI despliegan stacks Docker al QNAP y otros hosts Docker.
5. **Proxmox VE** (2 nodos + QDevice para quórum) proporciona la capa de virtualización que ejecuta tanto los clústeres Kubernetes como los hosts Docker.
6. **Kubernetes** ejecuta dos clústeres HA de k3s (producción + staging, 12 nodos en total).
7. **Docker** ejecuta 30+ servicios en 3 hosts standalone, incluyendo el QNAP NAS.
8. **Backups** siguen una estrategia de 3 niveles:
   - **Proxmox PBS**: copias locales de los guests de Proxmox, después sincronizadas a Backblaze B2.
   - **Backrest** (Docker en el QNAP): copias locales de los datos Docker, después enviadas a B2.
   - **Copia offline**: backup semanal a un disco externo.
9. **Observabilidad** (Grafana + Prometheus + Loki + Alertmanager) monitorea todo y envía alertas a Telegram.
10. **Secretos** están centralizados en 1Password (inyectados vía `op inject`), con SOPS/age para manifiestos cifrados en GitOps y Kyverno para políticas en runtime.

### Stack tecnológico

| Capa | Tecnología |
|------|-----------|
| Edge / Túnel | Pangolin, Cloudflare |
| VPN | WireGuard (road warrior en pfSense) |
| Git / CI | Forgejo (red privada Hetzner) |
| Virtualización | Proxmox VE (2 nodos + QDevice) |
| Orquestación | k3s (2 clústeres HA), Docker Compose (3 hosts) |
| GitOps | FluxCD |
| Ingress | Traefik (k3s + Docker), cert-manager, Let's Encrypt, external-dns |
| Load Balancer | MetalLB |
| Observabilidad | Grafana, Prometheus, Loki, Alertmanager |
| Secretos | 1Password, SOPS/age, Kyverno |
| IaC | OpenTofu, Ansible (modo pull) |
| Red | pfSense, VLANs, Pi-hole, Cloudflare DNS |
| Seguridad | CrowdSec (en todos los Traefik), políticas Kyverno, NetworkPolicies |
| Backups | Proxmox PBS → B2, Backrest (QNAP) → B2, disco offline semanal |
| Almacenamiento | NVMe local, iSCSI QNAP |