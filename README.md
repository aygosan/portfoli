# Portfoli

Personal portfolio website built with Hugo and PaperMod theme.

## Tech Stack

- **Hugo** — static site generator
- **PaperMod** — theme (git submodule)
- **Inter + JetBrains Mono** — typography
- **Kubernetes + Traefik** — deployment target
- **GitHub Actions + Pages** — CI/CD i hosting

## Languages

- Català (ca)
- English (en)
- Español (es)

## Local Development

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/aygosan/portfoli.git

# Serve locally
hugo server -D

# Build
hugo --minify
```

## Deploy

Pushing to `main` triggers:
1. Hugo build (GitHub Actions, `.github/workflows/static.yml`)
2. Publish to GitHub Pages → https://santi.ramisclar.cat

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
├── .github/workflows/ # CI/CD
└── (hosting: GitHub Pages — no k8s/ ni contenidors)
```

## License

MIT