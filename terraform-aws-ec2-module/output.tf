output "instance_id" {
  description = "ID de l'instance"
  value       = aws_instance.EC2.id
}

output "instance_private_ip" {
  description = "IP privée de l'instance"

  value = aws_instance.EC2.private_ip
}

output "instance_private_dns" {
  description = "DNS privé de l'instance"

  value = aws_instance.EC2.private_dns
}

