---
syntax: bash
tags: [ kubernetes, devops ]
---
# Check prerequisites
flux check --pre

# Install the latest version of Flux
flux install

# Create a source for a public Git repository
flux create source git webapp-latest \
--url=https://github.com/stefanprodan/podinfo \
--branch=master \
--interval=3m

# List GitRepository sources and their status
flux get sources git

# Trigger a GitRepository source reconciliation
flux reconcile source git flux-system

# Export GitRepository sources in YAML format
flux export source git --all > sources.yaml

# Create a Kustomization for deploying a series of microservices
flux create kustomization webapp-dev \
--source=webapp-latest \
--path="./deploy/webapp/" \
--prune=true \
--interval=5m \
--health-check="Deployment/backend.webapp" \
--health-check="Deployment/frontend.webapp" \
--health-check-timeout=2m

# Trigger a git sync of the Kustomization's source and apply changes
flux reconcile kustomization webapp-dev --with-source

# Suspend a Kustomization reconciliation
flux suspend kustomization webapp-dev

# Export Kustomizations in YAML format
flux export kustomization --all > kustomizations.yaml

# Resume a Kustomization reconciliation
flux resume kustomization webapp-dev

# Delete a Kustomization
flux delete kustomization webapp-dev

# Delete a GitRepository source
flux delete source git webapp-latest

# Uninstall Flux and delete CRDs
flux uninstall
