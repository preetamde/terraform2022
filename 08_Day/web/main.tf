# Pull Data
  # VPC Data
  data "aws_vpc" "mainvpc" {
    cidr_block = "10.10.0.0/16"
  }
  # subnet in Public Zone A
  data "aws_subnet" "publiczonea" {
    cidr_block = "10.10.10.0/24"
  }
# 1. search latest image id 
data "aws_ami" "recentami" {
  owners = [ "099720109477" ]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-hirsute-21.04-amd64-server-*"]
  }
}
# 2. create security group
resource "aws_security_group" "sg_webserver" {
  name = "sgp-dt-ec2-websrv"
  description = "Security group 80,22"
  vpc_id = data.aws_vpc.mainvpc.id
  ingress {
      to_port = 80
      from_port = 80
      protocol = "tcp"
      # cidr_blocks = [ "0.0.0.0/0" ]
      security_groups = ["sg-04521dd3d79e54f32"]
      description = "Allow 80"
  }
  ingress {
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow ssh"
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "internet access"
  }
}
# 3. aws ssh key
resource "aws_key_pair" "sshkeys" {
  public_key = file(var.sshkeyspublic)
  key_name = var.sshkeysprivate
}
# 4. create instance
resource "aws_instance" "apache" {
  ami = data.aws_ami.recentami.id
  instance_type = "t2.micro"
  user_data = file("webserver.sh")
  vpc_security_group_ids = [aws_security_group.sg_webserver.id] # tried, it must be square bracket.
  availability_zone = "us-east-2a"
  subnet_id = data.aws_subnet.publiczonea.id
  key_name = aws_key_pair.sshkeys.key_name
}

# 18.10.2021 apache works. I have to mention this. you know.