variable "aws_region" {
  type        = string
  description = "AWS region where infrastructure is deployed."
  default     = "us-east-2"
}

variable "project_name" {
  type        = string
  description = "Logical name for tagging and resource grouping."
  default     = "infra-platform"
}

variable "environment" {
  type        = string
  description = "Environment tag applied to all resources (dev/stage/prod)."
  default     = "dev"
}

variable "ami_id" {
  type        = string
  description = "AMI built with Packer that instances should boot from."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type used for the application host."
  default     = "t3.micro"
}

variable "instance_ssh_username" {
  type        = string
  description = "Default SSH username baked into the AMI (used for helper output)."
  default     = "ubuntu"
}

variable "ssh_key_name" {
  type        = string
  description = "Existing EC2 key pair name used for SSH access."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet hosting the instance."
  default     = "10.10.1.0/24"
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks permitted to SSH into the instance."
  default     = ["0.0.0.0/0"]
}

variable "node_exporter_port" {
  type        = number
  description = "Port where node_exporter listens (should match the AMI setting)."
  default     = 9100
}

variable "monitoring_allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to scrape node_exporter."
  default     = ["0.0.0.0/0"]
}

variable "extra_tags" {
  type        = map(string)
  description = "Additional tags merged into every resource."
  default     = {}
}
