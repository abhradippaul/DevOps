resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_name
  }
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "static_content" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "/image/image1.jpg"
  source       = "image1.jpg"
  content_type = "image/jpg"
  depends_on   = [aws_s3_bucket_policy.allow_public_access]
}

data "aws_iam_policy_document" "iam_allow_public_access" {
  statement {
    sid    = "AllowPublicAcess"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.iam_allow_public_access.json
  depends_on = [
    aws_s3_bucket_public_access_block.public_access
  ]
}
