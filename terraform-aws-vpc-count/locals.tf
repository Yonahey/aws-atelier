locals {
  owner        = "ic"
  tp           = "terraform-aws-vpc-dynamic"
  subnet_count = "3"
}

locals {
  default_tags = {
    Owner = local.owner
    TP    = local.tp
  }
}