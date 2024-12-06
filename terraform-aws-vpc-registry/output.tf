output "ec2module_instance_id" {
  value = module.ec2.instance_id
}

output "ec2_module_instance_private_ip" {
  value = module.ec2.instance_private_ip
}

output "ec2_module_instance_private_dns" {
  value = module.ec2.instance_private_dns
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {

  value = aws_subnet.main.id

}

