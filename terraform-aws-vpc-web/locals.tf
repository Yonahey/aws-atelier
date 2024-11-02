locals {
  owner = "ic"
  tp    = "terraform-aws-vpc-dynamic"
}

locals {
  default_tags = {
    Owner = local.owner
    TP    = local.tp
  }
}