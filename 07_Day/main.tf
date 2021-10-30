# First step create ssh keypair
resource "aws_key_pair" "webaccess" {
  key_name = var.private_key
  public_key = "${file("${var.public_key}")}"
}


resource "aws_instance" "webservx" {
  instance_type = "t2.micro"
  ami = "${lookup(var.amiid, var.AWS_REGION)}"
  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get -y install nginx
                EOF
    key_name = aws_key_pair.webaccess.key_name
    vpc_security_group_ids = [aws_security_group.sgwebservx.id]
  tags = {
    "Name" = "webserverngnix"
  }
}

resource "aws_security_group" "sgwebservx" {
  name = "AllowSSH80"
  ingress {
      to_port = 22
      from_port = 22
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "tcp"
      description = "Allow SSH"
  }
  ingress {
      to_port = 80
      from_port = 80
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "tcp"
      description = "allow http"
  }
  egress {
      to_port = 0
      from_port = 0
      protocol = -1
      cidr_blocks = [ "0.0.0.0/0" ]
  }
}

output "otsgwebservx" {
    value = aws_instance.webservx.public_ip
    description = "output of instances"
  
}