# create web server but without using AMI
provider "aws" {
  region = "us-east-2"
}

variable "tcp8080" {
  type = number
  description = "This is port for our web server"
  default = "8080"
}

data "aws_ami" "latestubuntu" {
  owners = [ "099720109477" ]
  most_recent = true
  filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "hello4b" {
  ami = data.aws_ami.latestubuntu.id
  instance_type = "t2.micro"
  user_data = <<-EOF
            #!/bin/bash
            echo "Sri Swami Samarth" >index.html
            nohup busybox httpd -f -p ${var.tcp8080} &
            EOF
  tags = {
    "Name" = "Hello4B"
  }
  vpc_security_group_ids = [ aws_security_group.sghello4b.id ]
}

resource "aws_security_group" "sghello4b" {
    name = "Allow_8080"
    ingress {
        to_port = var.tcp8080
        from_port = var.tcp8080
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}

output "hello4boutput" {
  description = "Out of hello4b instance"
  value = aws_instance.hello4b.public_ip
}