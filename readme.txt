This repo orchestrates the full pipeline: image creation → infrastructure provisioning → configuration management → monitoring/observability.

┌─────────────┐
│   PACKER    │  → Builds hardened OS images (base VM)
└──────┬──────┘
       │
┌──────▼──────┐
│  TERRAFORM  │  → Creates infrastructure (Droplets, networking, DNS, firewalls)
└──────┬──────┘
       │
┌──────▼──────┐
│   ANSIBLE   │  → Configures apps (Nginx, API, etc.) + sets up monitoring agents
└──────┬──────┘
       │
┌──────▼─────────────┐
│  PROMETHEUS STACK  │  → Collects metrics from your servers & apps
│     + GRAFANA      │  → Visualizes metrics, dashboards, and alerts
└────────────────────┘
