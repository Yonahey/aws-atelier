resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "error.html"
  source       = "./files/404.html"
  content_type = "text/html"
  etag         = filemd5("./files/404.html")
}