module "ec2" {
  source    = "../terraform-aws-ec2-module"
  subnet_id = aws_subnet.main.id
  instance_name_tag = "server"
  instance_count = "3"
}