# 01.10.2021 october
provider "aws" {
  region = "us-east-2"
}
variable "webserver_8080" {
  description = "port for the webserver"
  default = 8080
  type = number
}
resource "aws_instance" "day03_http" {
  instance_type = "t2.micro"
  ami = "ami-0c55b159cbfafe1f0"
  user_data = <<-EOF
                #!/bin/bash
                echo "Sri swami samarath" >index.html
                nohup busybox httpd -f -p ${var.webserver_8080} &
            EOF
  tags = {
    "Name" = "Webserverday03"
  }
  vpc_security_group_ids = [aws_security_group.instancerules.id]
}
resource "aws_security_group" "instancerules" {
  name = "Allow 8080"
  ingress {
      to_port = var.webserver_8080
      from_port = var.webserver_8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
output "instance_outputs" {
  description = "all outputs from the instances"
  value = aws_instance.day03_http.public_ip
}