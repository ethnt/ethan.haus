resource "aws_cloudfront_distribution" "site_distribution" {
  origin {
    origin_id = var.domain
    domain_name = aws_s3_bucket.site.bucket_domain_name
  }

  aliases = [ var.domain ]

  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = var.domain

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.certificate.arn
    ssl_support_method = "sni-only"
  }
}

resource "aws_cloudfront_distribution" "files_distribution" {
  origin {
    origin_id = var.files_domain
    domain_name = aws_s3_bucket.files.bucket_domain_name
  }

  aliases = [ var.files_domain ]

  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = var.files_domain
    response_headers_policy_id = aws_cloudfront_response_headers_policy.files_response_policy.id

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.certificate.arn
    ssl_support_method = "sni-only"
  }
}

resource "aws_cloudfront_response_headers_policy" "files_response_policy" {
  name = "files-response-policy"

  cors_config {
    access_control_allow_credentials = false

    access_control_allow_headers {
      items = [ "Content-Type", "ETag" ]
    }

    access_control_allow_methods {
      items = [ "GET", "OPTIONS", "HEAD" ]
    }

    access_control_allow_origins {
      items = [ "*" ]
    }

    origin_override = true
  }
}
