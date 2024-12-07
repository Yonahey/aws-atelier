output "all_instance_ids" {
  value = module.ec2.instance_ids
}

output "all_private_ips" {
  value = module.ec2.instance_private_ips
}

