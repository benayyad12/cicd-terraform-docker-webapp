resource "aws_instance" "ec2_instance_nginx" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                set -euxo pipefail

                IMAGE="${var.docker_image}"

                if command -v apt-get >/dev/null 2>&1; then
                  apt-get update -y
                  apt-get install -y docker.io
                  systemctl enable --now docker
                elif command -v yum >/dev/null 2>&1; then
                  yum update -y
                  (amazon-linux-extras install -y docker || true)
                  yum install -y docker
                  systemctl enable --now docker
                else
                  echo "Unsupported OS (no apt-get/yum)" >&2
                  exit 1
                fi

                docker pull "$IMAGE"
                docker rm -f webapp || true
                docker run -d --name webapp --restart unless-stopped -p 80:80 "$IMAGE"
                EOF

  tags = {
    Name = "vm for nginx webserver"
  }
}