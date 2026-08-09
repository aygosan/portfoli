# Santiago Ramis — Portfolio

Personal portfolio website built with Hugo and PaperMod theme.

## Tech Stack

- **Hugo** — static site generator
- **PaperMod** — theme (git submodule)
- **Inter + JetBrains Mono** — typography
- **Docker + nginx** — containerized serving
- **Kubernetes + Traefik** — deployment target
- **FluxCD** — GitOps deployment

## Languages

- English (en) — default
- Català (ca)
- Español (es)

## Local Development

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/haigosan/portfoli.git

# Serve locally
hugo server -D

# Build
hugo --minify
```

## Docker

```bash
docker build -t portfoli .
docker run -p 8080:80 portfoli
```

## Deploy

Pushing to `main` triggers:
1. Hugo build
2. Docker image build → push to `ghcr.io/haigosan/portfoli`
3. FluxCD detects new image and updates the deployment

### Kubernetes (GitOps)

Deployment is managed by **FluxCD** in the [`ramisclar/fluxcd`](https://github.com/ramisclar/fluxcd)
repo — see `apps/components/hugo/`. There are no in-repo Kubernetes manifests;
FluxCD is the single source of truth for the cluster state.

## Structure

```
.
├── hugo.toml          # Hugo config (multi-language, params, menus)
├── content/           # Content in EN, CA, ES
│   ├── en/
│   ├── ca/
│   └── es/
├── layouts/           # Custom layouts (hero, index, partials)
├── assets/css/        # Custom CSS (colors, typography, terminal)
├── themes/PaperMod/   # Theme (git submodule)
├── Dockerfile         # Multi-stage: Hugo build → nginx serve
├── nginx.conf         # Nginx config
├── .github/workflows/ # CI/CD
└── (no k8s/ — deployment via FluxCD in ramisclar/fluxcd)
```

## License

MIT