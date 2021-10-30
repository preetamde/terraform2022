# Pull the VPC and public subnet id
data "aws_vpc" "mainvpc" {
  cidr_block = "10.10.0.0/16"
}
data "aws_subnet" "zone2apublic" {
  cidr_block = "10.10.10.0/24"
}

# security group
resource "aws_security_group" "sginstance" {
  name = "SG for Instance"
  vpc_id = data.aws_vpc.mainvpc.id

  ingress {
      to_port = 22
      from_port = 22
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "tcp"
      description = "Admin Access"
  }
  ingress {
      to_port = 80
      from_port = 80
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "tcp"
      description = "Web Services"
  }
  egress {
      to_port = 0
      from_port = 0
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = -1
      description = "Internet Access-NATGW"
  }

}

# ssh key
resource "aws_key_pair" "devopskeys" {
  key_name = var.privatekey
  public_key = file(var.publickey)
}

# AMI latest

data "aws_ami" "ubuntu" {
  owners = [ "099720109477" ]
  most_recent = true
  filter {
    name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# lets create a web server here


resource "aws_instance" "webinstance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  availability_zone = var.az-a
  subnet_id = data.aws_subnet.zone2apublic.id
  vpc_security_group_ids = [ aws_security_group.sginstance.id ]
  key_name = aws_key_pair.devopskeys.key_name
  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get -y install nginx
                EOF
}

# add extra volume
resource "aws_ebs_volume" "data-drive" {
  availability_zone = var.az-a # required
  size = 20 # snapshot_id or size required
  type = "gp2"
  tags = {
    Name = "data-drive"
  }
}

# attached ebs volume to the instance

resource "aws_volume_attachment" "data-drive" {
  device_name = "/dev/sdm" #inside was mounted as /dev/xvdm. lslb can help
  volume_id = aws_ebs_volume.data-drive.id
  instance_id = aws_instance.webinstance.id
  stop_instance_before_detaching = true
}