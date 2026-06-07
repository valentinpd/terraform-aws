output "ec2_public_ip" {
  value       = aws_instance.web.public_ip
  description = "The public IP of the EC2 instance"
}

output "security_group_id" {
  value       = aws_security_group.web.id
  description = "The ID of the EC2 security group"
}
