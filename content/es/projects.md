---
title: "Proyectos"
date: 2026-08-09
draft: false
---

## Proyectos

### TekGarden — Plataforma Auto-Gestionada

**Rol:** Arquitecto y único operador

Un homelab convertido en plataforma de grado de producción funcionando 24/7 sobre Proxmox con Kubernetes, GitOps y observabilidad completa.

**Qué hace:**
- 2 clústeres HA de Kubernetes (producción + staging) — 12 nodos en total
- 3 hosts Docker ejecutando 30+ servicios
- Despliegues GitOps vía FluxCD (6 repos, reconcilia cada 1m)
- Stack de observabilidad completa (Grafana, Prometheus, Loki, Alertmanager → Telegram)
- Infraestructura como Código con Ansible (modo pull) y OpenTofu
- Secretos vía 1Password + SOPS/age + políticas Kyverno
- Backups a Proxmox PBS + Backblaze B2
- Forgejo self-hosted + runners de CI en el VPS de Hetzner

**Tecnologías:** k3s, FluxCD, Proxmox VE, Traefik, cert-manager, MetalLB, Grafana, Ansible, OpenTofu, Docker, 1Password, Kyverno, CrowdSec, OPNsense, Cloudflare

**Destacados:**
- Todo declarativo — sin cambios manuales de infraestructura
- Todos los cambios vía PR → merge → FluxCD aplica
- Pipeline de alertas de infraestructura a Telegram
- Documentación tratada como infraestructura (MkDocs, Diátaxis)

---

### Bot de Minecraft — agente autónomo en el juego

**Rol:** Arquitecto y desarrollador

Un bot de Minecraft autónomo que se conecta directamente al servidor del juego vía un plugin, capaz de interactuar con el mundo en tiempo real. Hace de puente entre agentes LLM y un entorno de juego con estado, a través de un protocolo estándar.

**Qué hace:**
- Acciones autónomas dentro del juego: pathfinding, construcción, chat
- Expuesto como servidor MCP (Model Context Protocol) para que agentes LLM puedan llamar acciones del juego como tools
- Funciona sobre infraestructura gestionada por GitOps

**Tecnologías:** Node.js, Mineflayer, MCP, TypeScript

**Destacados:**
- Conecta agentes LLM con un mundo de juego en tiempo real vía un protocolo estándar
- Un laboratorio para AI agentic en entornos reales con estado

---

### Casa inteligente — Home Assistant + Zigbee2MQTT

**Rol:** Arquitecto y operador

Un stack completo de casa inteligente basado en Home Assistant, con más de 40 dispositivos Zigbee emparejados vía Zigbee2MQTT y automatizaciones que van de las rutinas diarias a la monitorización de la infraestructura de TekGarden.

**Qué hace:**
- 40+ dispositivos Zigbee (sensores, luces, interruptores, etc.) emparejados vía Zigbee2MQTT
- Automatizaciones para rutinas diarias, detección de presencia y alertas
- Monitorea la infraestructura de TekGarden (uptime, alertas) y reacciona desde la capa de casa inteligente
- Music Assistant para control de audio multi-habitación integrado con la casa inteligente

**Tecnologías:** Home Assistant, Zigbee2MQTT, Music Assistant, ESPHome, MQTT

**Destacados:**
- La casa inteligente y el monitoreo de infraestructura se cruzan — las automatizaciones del hogar reaccionan a alertas de TekGarden
- Audio multi-habitación sincronizado vía Music Assistant

---

*Más proyectos próximamente.*