# Purpose: Deploy AWS instance in default workspace
resource "aws_key_pair" "devopskeys" {
  public_key = "${file("${var.sshpubkey}")}"
  key_name = var.sshpvtkey # name of the key pair.
}
resource "aws_instance" "helloinstance" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}" # ? AMI or rather map should be first in lookup 
  instance_type = "t2.micro"
  key_name = aws_key_pair.devopskeys.key_name
  vpc_security_group_ids = [ aws_security_group.sgforinst.id ]
  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get -y install nginx
                EOF
  tags = {
    "Name" = "helloinstance"
  }
}
resource "aws_security_group" "sgforinst" {
  name = "SG for Helloinstance"
  ingress {
      to_port = 22
      from_port = 22
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "tcp"
      description = "ssh access"
  }
  ingress {
      from_port = 80
      to_port = 80
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "tcp"
  }
  egress {
      from_port = 0
      to_port = 0
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = -1
  }
}

terraform {
  backend "s3" {
    bucket = "23072021terraformunr"
    dynamodb_table = "lockidtable"
    key = "workspace-example/terraform.tfstate"
    encrypt = true
    region = "us-east-2"
    profile = "terraform"
  }
}

output "publicip" {
  description = "public ip"
  value = aws_instance.helloinstance.public_ip
}