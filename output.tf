output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_id" {
  value = module.networking.public_subnet_id
}

output "web_sg_id" {
  value = aws_security_group.web-sg.id
}

output "public_ip" {
  value = aws_instance.web-server.public_ip
}