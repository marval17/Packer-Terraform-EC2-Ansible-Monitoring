# Codex Infrastructure Pipeline

End-to-end Infrastructure-as-Code example that bakes a hardened Ubuntu AMI with Packer, deploys it on AWS via Terraform, configures applications with Ansible (next), and feeds host metrics into a Prometheus + Grafana stack.

```
┌─────────────┐
│   PACKER    │  → Builds hardened AMIs (base VM + monitoring agent)
└──────┬──────┘
       │
┌──────▼──────┐
│  TERRAFORM  │  → Creates AWS infrastructure (VPC, subnet, EC2, security)
└──────┬──────┘
       │
┌──────▼──────┐
│   ANSIBLE   │  → Configures apps (Nginx, API, services) + app metrics
└──────┬──────┘
       │
┌──────▼─────────────┐
│  PROMETHEUS STACK  │  → Collects metrics from servers & apps
│     + GRAFANA      │  → Dashboards, alerting, visualizations
└────────────────────┘
```

## Repository layout

| Path | Description |
|------|-------------|
| `packer/` | Packer template, scripts, and vars for building the hardened Ubuntu AMI with node_exporter baked in. |
| `terraform/` | Terraform stack that provisions the AWS VPC/subnet/IGW, security groups, and EC2 instance sourced from the Packer AMI. |
| `ansible/` | (Placeholder) will host playbooks/roles for application configuration on the EC2 host. |
| `monitoring/` | (Placeholder) future Prometheus/Grafana manifests/configs. |

## Workflow

1. **Bake AMI** – `packer/templates/ubuntu-droplet` builds the base image: apt hardening, SSH lockdown, node_exporter install, firewall tuning. Outputs an AMI ID.
2. **Provision AWS** – `terraform/` consumes that AMI ID, builds the networking baseline, and launches a public EC2 instance with the hardened image.
3. **Configure Apps (Ansible)** – Playbooks will run against the Terraform outputs to deploy Nginx/API and any app-specific agents/secrets.
4. **Monitor** – Prometheus scrapes node_exporter (already baked in) and any future app exporters; Grafana dashboards/alerts visualize the system.

## Getting started

1. Build the AMI: follow `packer/templates/ubuntu-droplet/readme.md` (requires AWS creds + Packer).
2. Provision infra: follow `terraform/README.md`, supplying the AMI ID and an EC2 key pair.
3. (Upcoming) Run Ansible to install the app stack; deploy Prometheus/Grafana or hook into an existing monitoring cluster.

## Roadmap

- ✅ Hardened AMI with monitoring baked in.
- ✅ AWS VPC + EC2 bootstrap via Terraform.
- ☐ Ansible roles/playbooks for the app tier.
- ☐ Prometheus/Grafana deployment + dashboards.
- ☐ CI/CD automation tying Packer → Terraform → Ansible together.
