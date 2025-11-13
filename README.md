# Infrastructure Delivery Pipeline

End-to-end Infrastructure-as-Code workflow that bakes a hardened Ubuntu AMI with Packer, provisions AWS infrastructure via Terraform, (soon) configures apps with Ansible, and feeds telemetry into Prometheus + Grafana.

```
┌─────────────┐
│   PACKER    │ → Hardened AMI + monitoring agent
└──────┬──────┘
       │
┌──────▼──────┐
│  TERRAFORM  │ → AWS VPC, subnet, SGs, EC2
└──────┬──────┘
       │
┌──────▼──────┐
│   ANSIBLE   │ → App + service configuration
└──────┬──────┘
       │
┌──────▼─────────────┐
│ PROMETHEUS/GRAFANA │ → Metrics, dashboards, alerts
└────────────────────┘
```

## Repository layout

| Path | Description |
|------|-------------|
| `packer/` | Packer template, scripts, and env vars for building the hardened Ubuntu AMI with node_exporter baked in. |
| `terraform/` | Terraform configuration that creates the AWS VPC, subnet, internet gateway, security groups, and launches the EC2 instance from the AMI. |
| `ansible/` | Placeholder for upcoming playbooks/roles that layer the application stack onto the EC2 host. |
| `monitoring/` | Placeholder for Prometheus + Grafana deployment manifests/config. |

## Workflow

1. **Bake AMI** – Run `packer/templates/ubuntu-droplet` to harden Ubuntu, lock down SSH, install node_exporter, and produce an AMI ID.
2. **Provision AWS** – Feed that AMI ID into `terraform/` to create the network + EC2 host (public IP, security groups, etc.).
3. **Configure Apps** – Use Ansible (coming soon) against the Terraform outputs to install Nginx/API services and any app-specific agents.
4. **Monitor** – Point Prometheus at node_exporter (already on the image) and expose dashboards/alerts through Grafana.

## Getting started

1. Build the AMI: follow `packer/templates/ubuntu-droplet/readme.md` (requires AWS credentials + Packer 1.8+).
2. Deploy infrastructure: follow `terraform/README.md`, supplying the AMI ID and an existing EC2 key pair via `terraform.tfvars` or `-var`.
3. Apply Ansible roles for the app stack, then deploy Prometheus/Grafana or hook into an existing monitoring cluster.


