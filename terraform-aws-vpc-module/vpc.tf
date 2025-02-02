module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-east-1a", "eu-east-1b", "eu-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
  public_subnets  = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}