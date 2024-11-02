module "s3" {
  source        = "../ic-s3-module"
  index_file    = "./files/index.html"
  error_file    = "./files/404.html"
  owner         = "ic"
  bucket_prefix = "overide-prefix-"
}

output "my_s3_url" {
  value = module.s3.public_url
}