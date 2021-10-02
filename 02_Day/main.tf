provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "lt123" {
  instance_type = "t2.micro"
  ami = "ami-0c55b159cbfafe1f0"
  vpc_security_group_ids = [aws_security_group.lt123secgroup.id]
  user_data = <<-EOF
              #! /bin/bash
              echo "Sri Swami Samarth" >index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    "Name" = "pmz-useast02"
  }
}

resource "aws_security_group" "lt123secgroup" {
  name = "8080_Allow"
  ingress {
    to_port = "8080"
    from_port = "8080"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}