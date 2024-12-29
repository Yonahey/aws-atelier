output "instance_ids" {
  description = "ID de l'instance"
  value       = [for i in aws_instance.EC2 : i.id ]

}

output "instance_private_ips" {
  description = "IP privée de l'instance"
    value       = [for i in aws_instance.EC2 : i.private_ip ]

}
