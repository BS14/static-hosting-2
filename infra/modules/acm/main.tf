resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = { Name = "${var.project}-${var.env}-cert" }

  lifecycle {
    create_before_destroy = true
  }
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}
