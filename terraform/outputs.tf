output "instance_id" {
  description = "EC2 instance ID for the application host."
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Public IPv4 address assigned to the instance."
  value       = aws_instance.app.public_ip
}

output "ssh_command" {
  description = "Helper SSH command using the expected username."
  value       = "ssh ${var.instance_ssh_username}@${aws_instance.app.public_ip}"
}
