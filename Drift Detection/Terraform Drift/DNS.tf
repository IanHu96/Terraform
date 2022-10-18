#Needs to be Edited#
data "aws_route53_zone" "primary" {
  name         = "gitops-demo.com."
  private_zone = false
}

resource "aws_route53_record" "drift" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "drift.gitops-demo.com"
  type    = "A"
  ttl     = "300"
  records = ["8.8.8.8"]
}
