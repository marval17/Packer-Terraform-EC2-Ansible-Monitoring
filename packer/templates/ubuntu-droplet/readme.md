# Ubuntu AMI Packer Template

Builds a hardened Ubuntu 22.04 AMI on AWS that Terraform/Ansible can reuse.

## Prereqs
- Packer >= 1.8
- AWS account + IAM user/role with permissions to describe/build AMIs (`ec2:*Image*`, `ec2:RunInstances`, etc.)
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and (optionally) `AWS_SESSION_TOKEN` exported in your shell

## Files
- `template.pkr.hcl` - amazon-ebs builder plus hardening/monitoring provisioners
- `variables.pkr.hcl` - input variables (region, AMI filters, monitoring, etc.)
- `../../scripts/base-hardening.bash` - baseline OS lockdown
- `../../scripts/install-monitoring.bash` - installs/configures node_exporter
- `../../vars/*.pkrvars.hcl` - sample env overrides (see `vars/dev.pkrvars.hcl`)

## Monitoring bits baked in
The image ships with Prometheus `node_exporter`, preconfigured textfile collector support, and UFW holes for the scrape port. Adjust `node_exporter_*` and `monitoring_allowed_cidrs` variables (or environment overrides) to lock it down per environment.

## Usage
```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
# export AWS_SESSION_TOKEN=...   # if using temporary creds

cd packer/templates/ubuntu-droplet
packer init .
packer build \
  -var-file=../../vars/dev.pkrvars.hcl \
  .
```

`dev.pkrvars.hcl` ships with defaults targeting Canonical's Ubuntu 22.04 AMI in `us-east-2`. Override `source_ami_*`, region, or monitoring settings as needed. On success, Packer prints the AMI ID published by the `amazon-ebs.ubuntu` build, which Terraform can reference.
