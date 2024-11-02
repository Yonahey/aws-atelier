# bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket_prefix = var.bucket_prefix
  tags = {
    Owner = var.owner
    TP    = "terraform-s3-module"
  }
}
#website
resource "aws_s3_bucket_website_configuration" "webstatic" {
  bucket = aws_s3_bucket.my_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# public access
resource "aws_s3_bucket_public_access_block" "webstatic" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false



}
# error
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "error.html"
  source       = var.error_file
  content_type = "text/html"
  etag         = filemd5("${var.error_file}")
}
# index
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "index.html"
  source       = var.index_file
  content_type = "text/html"
  etag         = filemd5("${var.index_file}")
}
#policy
# resource "aws_s3_bucket_policy" "allow_anonymous_access" {
#   bucket = aws_s3_bucket.my_bucket.id
#   policy = data.aws_iam_policy_document.allow_anonymous_access.json
# }

data "aws_iam_policy_document" "allow_anonymous_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.my_bucket.arn}/*"
    ]
  }
}


