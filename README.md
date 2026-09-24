# Homebrew Tap for The Attic AI

## Install

```bash
brew tap sjonas50/tap
brew trust --formula sjonas50/tap/attic-ai   # Homebrew 7+ loads third-party formulae only once trusted
brew install attic-ai
attic-ai-install
```

## Usage

```bash
# Install and start all services (run it again after `brew upgrade attic-ai`)
attic-ai-install

# Open in browser
open http://localhost:3333

# Remove all containers, images and data
attic-ai-uninstall
```

Configuration (`.env`, with the generated secrets) lives in `~/.attic-ai`, the
same directory the one-line installer uses, so it survives upgrades. Set
`ATTIC_AI_HOME` to use another directory.

## Requirements

- macOS (Apple Silicon or Intel) or Linux
- [Docker Desktop](https://www.docker.com/products/docker-desktop/), or Docker Engine with the compose plugin
- Internet connection for the first install (~3 GB of Docker images plus 1–5 GB of AI models)

## New release

Point the formula at the new release's Docker bundle; Homebrew downloads it and
fills in the checksum:

```bash
brew bump-formula-pr --url=https://github.com/sjonas50/TheAtticAI/releases/download/vX.Y.Z/attic-ai-vX.Y.Z-docker.zip sjonas50/tap/attic-ai
```
