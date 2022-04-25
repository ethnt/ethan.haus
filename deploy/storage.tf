resource "aws_s3_bucket" "primary" {
  bucket = var.domain
}

resource "aws_s3_bucket_policy" "primary_policy" {
  bucket = aws_s3_bucket.primary.id
  policy = <<EOF
    {
      "Version": "2008-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::ethan.haus/*"
        }
      ]
    }
  EOF
}

resource "aws_s3_bucket_website_configuration" "primary" {
  bucket = aws_s3_bucket.primary.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket" "assets" {
  bucket = "assets.${var.domain}"
}

resource "aws_s3_bucket_policy" "assets_policy" {
  bucket = aws_s3_bucket.assets.id
  policy = <<EOF
    {
      "Version": "2008-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::assets.ethan.haus/*"
        }
      ]
    }
  EOF
}

resource "aws_s3_bucket_cors_configuration" "assets_cors" {
  bucket = aws_s3_bucket.assets.bucket

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_website_configuration" "assets" {
  bucket = aws_s3_bucket.assets.bucket

  index_document {
    suffix = "index.html"
  }
}
