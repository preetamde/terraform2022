# Create EIP
resource "aws_eip" "publicip" {
vpc = true
}
# create zone inside route 53
resource "aws_route53_zone" "preetamde" {
  name = "preetamde.com"
}

# create a A record for the webserver
resource "aws_route53_record" "webserver" {
  zone_id = aws_route53_zone.preetamde.id
  name = "www.preetamde.com"
  type = "A"
  ttl = "300"
  records = [aws_eip.publicip.public_ip]
}


