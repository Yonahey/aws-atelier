locals {
  owner        = "ic"
  tp           = "terraform-aws-vpc-count"
  subnet_count = "3"
  name = "dynamic_subnet"
  current_date = formatdate("YYYY-MM-DD", timestamp())
}

locals {
  default_tags = {
    Owner = local.owner
    TP    = local.tp
  }
}