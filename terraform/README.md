# Terraform AWS Stack

Provisions the minimum AWS infrastructure needed to run the hardened AMI built via Packer: network (VPC, subnet, internet gateway), security group rules, and a single EC2 instance with a public IP.

## Prereqs
- Terraform >= 1.5
- AWS credentials exported (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, optional `AWS_SESSION_TOKEN`)
- Packer-built AMI ID available in `us-east-2`
- Existing EC2 key pair name (Terraform references it; it does **not** create a new key)

## Key inputs
| Variable | Description |
| --- | --- |
| `ami_id` | Required. AMI ID output from the Packer build.
| `ssh_key_name` | Required. Existing key pair for SSH access.
| `ssh_allowed_cidrs` | CIDRs allowed to reach port 22.
| `monitoring_allowed_cidrs` | CIDRs allowed to scrape node_exporter.
| `extra_tags` | Optional map merged into every resource tag.

See `variables.tf` for the full list plus defaults (region `us-east-2`, subnet/VPC CIDRs, instance type, etc.).

## Usage
Create a `terraform.tfvars` (or pass `-var` flags) with required inputs, e.g.

```hcl
ami_id         = "ami-0123456789abcdef0"
ssh_key_name   = "my-ssh-key"
ssh_allowed_cidrs = [
  "203.0.113.10/32",
]
monitoring_allowed_cidrs = [
  "10.20.0.0/16",
]
extra_tags = {
  Owner = "infra"
}
```

Then run:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Outputs include the instance ID, public IP, and a ready-to-copy SSH command using the username baked into the AMI (default `ubuntu`).
