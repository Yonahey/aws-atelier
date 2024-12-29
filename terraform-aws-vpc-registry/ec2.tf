module "ec2" {
  source    = "../terraform-aws-ec2-module"
  subnets = local.subnets
  instance_name_tag = "server"
}