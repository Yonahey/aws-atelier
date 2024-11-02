output "public_url" {
  value = aws_s3_bucket_website_configuration.webstatic.website_endpoint
}
