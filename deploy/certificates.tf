# CloudFront requires that certificates it uses are in us-east-1, so we have to use a different provider here
provider "aws" {
  alias = "acm"
  region = "us-east-1"

  default_tags {
    tags = {
      Project = "ethan.haus"
    }
  }
}

resource "aws_acm_certificate" "certificate" {
  provider = aws.acm

  domain_name = var.domain
  validation_method = "DNS"

  subject_alternative_names = [ "*.${var.domain}" ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  provider = aws.acm

  certificate_arn = aws_acm_certificate.certificate.arn

  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}
