resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "index.html"
  source       = "./files/index.html"
  content_type = "text/html"
  etag         = filemd5("./files/index.html")
}