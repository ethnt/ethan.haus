resource "aws_s3_bucket" "deploy" {
  bucket = "deploy.ethan.haus"
}

resource "aws_s3_bucket_ownership_controls" "deploy_ownership" {
  bucket = aws_s3_bucket.deploy.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "deploy_acl" {
  bucket = aws_s3_bucket.deploy.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "deploy_versioning" {
  bucket = aws_s3_bucket.deploy.id

  versioning_configuration {
    status = "Enabled"
  }
}
