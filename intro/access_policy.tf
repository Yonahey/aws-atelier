resource "aws_s3_bucket_policy" "allow_anonymous_access" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = data.aws_iam_policy_document.allow_anonymous_access.json
}

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

