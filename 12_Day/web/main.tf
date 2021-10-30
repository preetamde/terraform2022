resource "aws_key_pair" "instancekey" {
  key_name   = var.sshprivatekey
  public_key = file("${var.sshpublickey}")
}

data "terraform_remote_state" "dbdetails" {
  backend = "local"
  config = {
    path = "/Users/preetamzare/Documents/Terraform/terraformdays/11_Day/Data/terraform.tfstate"
  }
}

data "template_file" "userdatainputs" {
  template = file("userdata.sh")
  vars = {
    dbstring = data.terraform_remote_state.dbdetails.outputs.dbstring
    dbarn    = data.terraform_remote_state.dbdetails.outputs.dbarn
  }
}
resource "aws_instance" "instance" {
  ami                    = lookup(var.amiids, var.AWS_REGION)
  instance_type          = "t2.micro"
  user_data              = data.template_file.userdatainputs.rendered # this is important line.
  key_name               = aws_key_pair.instancekey.key_name 
  vpc_security_group_ids = [aws_security_group.instancesg.id]
}

resource "aws_security_group" "instancesg" {
  name = "Instance Access"
  ingress {
    to_port     = 22
    from_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    description = "Allow SSH"
  }
  ingress {
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow web services"
  }
  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "internet access"
  }
}