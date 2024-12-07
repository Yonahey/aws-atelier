output "instance_ids" {
  description = "ID de l'instance"
  value       = aws_instance.EC2[*].id
}

output "instance_private_ips" {
  description = "IP privée de l'instance"

  value = aws_instance.EC2[*].private_ip
}
