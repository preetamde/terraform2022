# 02.10.2021

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "helloworld021021" {
    ami = "ami-09dd2e08d601bff67"
    instance_type = "t2.micro"

    tags = {
        "Name" = "HelloWorld"
    }

}