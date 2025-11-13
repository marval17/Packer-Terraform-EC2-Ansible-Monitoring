variable "aws_region" {
  type        = string
  description = "AWS region where the AMI is built."
  default     = "us-east-2"
}

variable "instance_type" {
  type        = string
  description = "Temporary instance type used while building the AMI."
  default     = "t3.micro"
}

variable "ssh_username" {
  type        = string
  description = "Username Packer uses to connect after the instance boots."
  default     = "ubuntu"
}

variable "source_ami_owner" {
  type        = string
  description = "AWS account ID that owns the base AMI (Canonical for Ubuntu)."
  default     = "099720109477"
}

variable "source_ami_name" {
  type        = string
  description = "Name filter used to locate the base Ubuntu 22.04 AMI."
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "root_volume_size" {
  type        = number
  description = "Size in GB for the root EBS volume attached during build."
  default     = 30
}

variable "ami_name_prefix" {
  type        = string
  description = "Prefix used when naming the resulting AMI."
  default     = "ubuntu-base"
}

variable "image_environment" {
  type        = string
  description = "Tag/label applied to the AMI for identification."
  default     = "dev"
}

variable "node_exporter_port" {
  type        = number
  description = "Port where node_exporter listens for Prometheus scrapes."
  default     = 9100
}

variable "node_exporter_listen_address" {
  type        = string
  description = "Bind address (host:port) node_exporter uses; defaults to all interfaces."
  default     = ":9100"
}

variable "monitoring_allowed_cidrs" {
  type        = list(string)
  description = "Optional CIDR blocks allowed through UFW to scrape node_exporter."
  default     = []
}
