packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  snapshot_suffix = formatdate("YYYYMMDDHHmmss", timestamp())
}

source "amazon-ebs" "ubuntu" {
  region        = var.aws_region
  instance_type = var.instance_type
  ssh_username  = var.ssh_username
  ami_name      = "${var.ami_name_prefix}-${local.snapshot_suffix}"
  ami_description = "Hardened Ubuntu 22.04 base image built via Packer"
  associate_public_ip_address = true

  source_ami_filter {
    most_recent = true
    owners      = [var.source_ami_owner]

    filters = {
      name                = var.source_ami_name
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
  }

  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name        = "packer-ubuntu-base"
    Environment = var.image_environment
    BuiltBy     = "packer"
  }

  ami_tags = {
    Name        = "${var.ami_name_prefix}-${local.snapshot_suffix}"
    Environment = var.image_environment
    BuiltBy     = "packer"
  }
}

build {
  name    = "ubuntu-ami"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = "${path.root}/../../scripts/base-hardening.bash"
  }

  provisioner "shell" {
    script = "${path.root}/../../scripts/install-monitoring.bash"
    environment_vars = [
      "NODE_EXPORTER_PORT=${var.node_exporter_port}",
      "NODE_EXPORTER_LISTEN_ADDRESS=${var.node_exporter_listen_address}",
      "MONITORING_ALLOWED_CIDRS=${join(",", var.monitoring_allowed_cidrs)}",
    ]
  }
}
