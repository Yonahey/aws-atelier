locals {
  vpc_cidr = "10.1.0.0/16"
  owner        = "ic"
  tp           = "terraform-aws-vpc-dynamic"
  subnets = {
    "10.1.0.0/24" = "us-east-1a"
    "10.1.1.0/24" = "us-east-1b"
    "10.1.2.0/24" = "us-east-1c"
  }
  region = "us-east-1"
  date = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
}

locals {
  default_tags = {
    Owner = local.owner
    TP    = local.tp
  }

}