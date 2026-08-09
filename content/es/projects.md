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

**Tecnologías:** k3s, FluxCD, Proxmox VE, Traefik, cert-manager, MetalLB, Grafana, Ansible, OpenTofu, Docker, 1Password, Kyverno, CrowdSec, pfSense, Cloudflare

**Destacados:**
- Todo declarativo — sin cambios manuales de infraestructura
- Todos los cambios vía PR → merge → FluxCD aplica
- Pipeline de alertas de infraestructura a Telegram
- Documentación tratada como infraestructura (MkDocs, Diátaxis)

---

### openclaw — Rumi, el bot de Minecraft

**Rol:** Arquitecto y desarrollador

Un bot de Minecraft construido con [Mineflayer](https://github.com/PrismarineJS/mineflayer) y expuesto como servidor MCP (Model Context Protocol), permitiendo que agentes LLM perciban y actúen en el mundo del juego.

**Qué hace:**
- Bot autónomo de Minecraft con pathfinding, construcción y chat
- Interfaz de servidor MCP para que agentes LLM puedan llamar acciones del juego como tools
- Vive en su propio repo gestionado por GitOps con servicios LXC

**Tecnologías:** Node.js, Mineflayer, MCP, TypeScript

**Destacados:**
- Conecta agentes LLM con un mundo de juego en tiempo real vía un protocolo estándar
- Un laboratorio para AI agentic en entornos reales con estado

---

*More proyectos coming soon.*