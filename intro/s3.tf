resource "aws_s3_bucket" "my_bucket" {
  bucket_prefix = "ic-cde-"
  tags = {
    Owner = "ic"
    TP    = "terraform-s3-aws"
  }
}