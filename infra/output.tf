# VPC / Networking
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "route_table_id" {
  description = "Route table ID"
  value       = aws_route_table.public_rt.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "security_group_id" {
  description = "EC2 security group ID"
  value       = aws_security_group.ec2_sg.id
}

# EC2
output "ec2_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "ec2_public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.web.public_ip
}

output "ec2_public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.web.public_dns
}

# Useful meta
output "project_name" {
  value = var.project_name
}

output "aws_region" {
  value = var.aws_region
}
