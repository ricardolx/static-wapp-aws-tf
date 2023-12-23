

resource "aws_waf_web_acl" "waf_acl" {
  name        = "my-waf-acl"
  metric_name = "wafacl"

  default_action {
    type = "ALLOW"
  }
}

# CloudFront distribution with WAF
resource "aws_cloudfront_distribution" "webapp_distribution" {
  origin {
    domain_name = aws_lb.webapp_lb.dns_name
    origin_id   = aws_lb.webapp_lb.arn
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["temp-cloudfront-alias"]

  # Add other CloudFront configuration settings as needed

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lb.webapp_lb.arn

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_100"

  tags = {
    Environment = "production"
  }

  # WAF configuration (create AWS WAF WebACL before using it here)
  web_acl_id = aws_waf_web_acl.waf_acl.id
  depends_on = [aws_lb.webapp_lb]
}

