# create a EC2 instance with ssh keys

provider "aws" {
  region = "us-east-2"
}

variable "sshport" {
  description = "SSH port to access the instance"
  default     = 22
  type        = number
}

variable "http8080" {
  description = "http port for the web server"
  default     = 8080
  type        = number
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_security_group" "access22" {
  name = "AllowAccess22"
  ingress {
    to_port     = var.sshport
    from_port   = var.sshport
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow SSH Access"
  }
  ingress {
    to_port     = var.http8080
    from_port   = var.http8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow http at 8080"
  }
}

resource "aws_instance" "firstinstance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = <<-EOF
                #!/bin/bash
                echo "Sri Swami Samarath" >index.html
                nohup busybox httpd -f -p ${var.http8080} &
                EOF
  key_name      = "devops"
  tags = {
    "Name" = "terraformins01"
  }
  vpc_security_group_ids = [aws_security_group.access22.id]

}

output "instanceotps" {
  description = "outputs from the instance"
  value = aws_instance.firstinstance.public_ip
}