provider "aws" {
  region = var.region
}

resource "aws_cloudfront_distribution" "frontend_distribution" {
  aliases = var.workspace == "dev" ? ["dev.mydomain.com"] : ["prod.mydomain.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-${var.frontend_bucket_name}"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
  }

  default_root_object = "index.html"

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}
