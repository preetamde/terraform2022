# 1. search latest image id 
data "aws_ami" "recentami" {
  owners = [ "value" ]
  most_recent = true
  filter {
    name = "name"
    values = [""]
  }
}

# 2. create security group
resource "aws_security_group" "SG_webserver" {
  name = "sgp-dt-ec2-websrv"
  description = "Security group 80,22"
  ingress {
      to_port = 80
      from_port = 80
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Allow 80"
  }
}


# 3. create instance