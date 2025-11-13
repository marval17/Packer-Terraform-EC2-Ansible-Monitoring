# Prometheus + Grafana Stack

Docker Compose deployment that scrapes the AWS EC2 node_exporter endpoint and provides pre-wired Grafana dashboards.

## Prereqs
- Docker + Docker Compose Plugin
- Access to the node_exporter endpoint baked into the AMI (public IP or private IP with connectivity)
- Optional: `.env` file to override Grafana admin credentials (`GRAFANA_ADMIN_USER`, `GRAFANA_ADMIN_PASSWORD`)

## Usage
1. Edit `prometheus/prometheus.yml` and replace `REPLACE_WITH_NODE_EXPORTER_IP` with the public (or private) IP/hostname of your EC2 instance.
2. (Optional) Create a `.env` file alongside `docker-compose.yml` to override Grafana admin creds:
   ```bash
   GRAFANA_ADMIN_USER=admin
   GRAFANA_ADMIN_PASSWORD=supersecret
   ```
3. Launch the stack:
   ```bash
   cd monitoring
   docker compose up -d
   ```
4. Access Prometheus at `http://localhost:9090` and Grafana at `http://localhost:3000` (default login `admin / changeme`). The included Grafana datasource and dashboard load automatically.

## Files
- `docker-compose.yml` – defines Prometheus + Grafana services, persistent volumes, and provisioning mounts.
- `prometheus/prometheus.yml` – scrape config for Prometheus; customize targets here.
- `grafana/provisioning/*` – auto-provisioned datasource + dashboard definitions.
- `grafana/dashboards/node-exporter-overview.json` – starter dashboard visualizing CPU, memory, disk, and network metrics from node_exporter.

Adjust scrape targets or add additional dashboards/datasources as your infrastructure grows.
