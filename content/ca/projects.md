---
title: "Projectes"
date: 2026-08-09
draft: false
---

## Projectes

### TekGarden — Plataforma Auto-Gestionada

**Rol:** Arquitecte i únic operador

Un homelab convertit en plataforma de grau de producció funcionant 24/7 sobre Proxmox amb Kubernetes, GitOps i observabilitat completa.

**Què fa:**
- 2 clústers HA de Kubernetes (producció + staging) — 12 nodes en total
- 3 hosts Docker executant 30+ serveis
- Desplegaments GitOps via FluxCD (6 repos, reconcilia cada 1m)
- Stack d'observabilitat completa (Grafana, Prometheus, Loki, Alertmanager → Telegram)
- Infraestructura com a Codi amb Ansible (mode pull) i OpenTofu
- Secrets via 1Password + SOPS/age + policies Kyverno
- Backups a Proxmox PBS + Backblaze B2
- Forgejo self-hosted + runners de CI al VPS de Hetzner

**Tecnologies:** k3s, FluxCD, Proxmox VE, Traefik, cert-manager, MetalLB, Grafana, Ansible, OpenTofu, Docker, 1Password, Kyverno, CrowdSec, pfSense, Cloudflare

**Destacats:**
- Tot declaratiu — sense canvis manuals d'infraestructura
- Tots els canvis via PR → merge → FluxCD aplica
- Pipeline d'alertes d'infraestructura a Telegram
- Documentació tractada com a infraestructura (MkDocs, Diátaxis)

---

### Bot de Minecraft — agent autònom dins el joc

**Rol:** Arquitecte i desenvolupador

Un bot de Minecraft autònom que es connecta directament al servidor del joc via un plugin, capaç d'interactuar amb el món en temps real. Fa de pont entre agents LLM i un entorn de joc amb estat, a través d'un protocol estàndard.

**Què fa:**
- Accions autònomes dins el joc: pathfinding, construcció, xat
- Exposat com a servidor MCP (Model Context Protocol) perquè agents LLM puguin cridar accions del joc com a tools
- Funciona sobre infraestructura gestionada per GitOps

**Tecnologies:** Node.js, Mineflayer, MCP, TypeScript

**Destacats:**
- Connecta agents LLM amb un món de joc en temps real via un protocol estàndard
- Un laboratori per a AI agentic en entorns reals amb estat

---

### Casa intel·ligent — Home Assistant + Zigbee2MQTT

**Rol:** Arquitecte i operador

Un stack complet de casa intel·ligent basat en Home Assistant, amb més de 40 dispositius Zigbee emparellats via Zigbee2MQTT i automatitzacions que van de les rutines diàries a la monitorització de la infraestructura del TekGarden.

**Què fa:**
- 40+ dispositius Zigbee (sensors, llums, interruptors, etc.) emparellats via Zigbee2MQTT
- Automatitzacions per a rutines diàries, detecció de presència i alertes
- Monitoritza la infraestructura del TekGarden (uptime, alertes) i reacciona des de la capa de casa intel·ligent
- Music Assistant per al control d'àudio multi-habitació integrat amb la casa intel·ligent

**Tecnologies:** Home Assistant, Zigbee2MQTT, Music Assistant, ESPHome, MQTT

**Destacats:**
- La casa intel·ligent i la monitorització d'infraestructura es creuen — les automatitzacions de casa reaccionen a alertes del TekGarden
- Àudio multi-habitació sincronitzat via Music Assistant

---

*More projectes coming soon.*