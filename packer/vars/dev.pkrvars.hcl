# Sample vars file for dev builds. Override values or copy per environment.
aws_region                     = "us-east-2"
instance_type                  = "t3.micro"
ssh_username                   = "ubuntu"
source_ami_owner               = "099720109477"
source_ami_name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
root_volume_size               = 30
ami_name_prefix                = "ubuntu-base-dev"
image_environment              = "dev"
node_exporter_port             = 9100
node_exporter_listen_address   = ":9100"
monitoring_allowed_cidrs       = [
  "10.10.0.0/16",
  "192.168.0.0/24",
]
