provider "aws" {
  region = var.region
}

resource "aws_route53_zone" "mydomain_zone" {
  name = var.workspace == "dev" ? "dev.mydomain.com" : "prod.mydomain.com"
}

resource "aws_route53_record" "cloudfront_record" {
  zone_id = aws_route53_zone.mydomain_zone.id
  name    = var.workspace == "dev" ? "dev.mydomain.com" : "prod.mydomain.com"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.frontend_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.frontend_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
