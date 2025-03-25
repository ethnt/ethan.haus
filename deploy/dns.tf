resource "aws_route53_zone" "ethan_haus" {
  name = "ethan.haus"
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.ethan_haus.zone_id
  name    = "ethan.haus"
  type    = "A"
  ttl     = 300
  records = ["76.76.21.21"]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.ethan_haus.zone_id
  name    = "www.ethan.haus"
  type    = "CNAME"
  ttl     = 300
  records = ["ethan.haus"]
}

resource "aws_route53_record" "atproto" {
  zone_id = aws_route53_zone.ethan_haus.zone_id
  name    = "_atproto.ethan.haus"
  type    = "TXT"
  ttl     = 300
  records = ["did=did:plc:7k5xzwqxohs5pclby5vm3cf5"]
}

resource "aws_route53_record" "_2024" {
  zone_id = aws_route53_zone.ethan_haus.zone_id
  name    = "2024.ethan.haus"
  type    = "CNAME"
  ttl     = 300
  records = ["cname.vercel-dns.com"]
}
