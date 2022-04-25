resource "aws_s3_bucket" "site" {
  bucket = var.domain
}

resource "aws_s3_bucket_policy" "site_policy" {
  bucket = aws_s3_bucket.site.id
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
          "Resource": "arn:aws:s3:::${aws_s3_bucket.site.bucket}/*"
        }
      ]
    }
  EOF
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket" "files" {
  bucket = var.files_domain
}

resource "aws_s3_bucket_policy" "files_policy" {
  bucket = aws_s3_bucket.files.id
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
          "Resource": "arn:aws:s3:::${aws_s3_bucket.files.bucket}/*"
        }
      ]
    }
  EOF
}

resource "aws_s3_bucket_cors_configuration" "files_cors" {
  bucket = aws_s3_bucket.files.bucket

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_website_configuration" "files" {
  bucket = aws_s3_bucket.files.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket" "deploy" {
  bucket = "deploy.ethan.haus"
}

resource "aws_s3_bucket_versioning" "deploy" {
  bucket = aws_s3_bucket.deploy.id

  versioning_configuration {
    status = "Enabled"
  }
}
