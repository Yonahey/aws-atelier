terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.5"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
  default_tags {
    tags = local.default_tags
  }
}

provider "cloudinit" {
  # Configuration options
}