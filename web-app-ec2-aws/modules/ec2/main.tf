resource "aws_instance" "ec2_instance_nginx" {
  ami           =  var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "vm for nginx webserver"
  }
}