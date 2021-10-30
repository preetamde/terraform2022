resource "aws_instance" "ins051021" {
  ami = "${lookup(var.amis, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "devops"
}