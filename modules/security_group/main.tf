resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.wrapper_vpc_id

  tags = {
    Name = "allow_tls"
  }
}