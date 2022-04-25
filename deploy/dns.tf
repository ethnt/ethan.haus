resource "aws_route53_zone" "primary" {
  name = "ethan.haus"
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = aws_route53_zone.primary.zone_id
}

resource "aws_route53_record" "site" {
  zone_id = aws_route53_zone.primary.zone_id
  name = var.domain
  type = "A"

  alias {
    name = aws_cloudfront_distribution.site_distribution.domain_name
    zone_id = aws_cloudfront_distribution.site_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "files" {
  zone_id = aws_route53_zone.primary.zone_id
  name = var.files_domain
  type = "A"

  alias {
    name = aws_cloudfront_distribution.files_distribution.domain_name
    zone_id = aws_cloudfront_distribution.files_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
