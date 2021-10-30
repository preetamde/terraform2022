variable "region" {
  type = string
  description = "The AWS Region"
  default = "us-east-2"
}
variable "key_name" {
  type = string
  description = "The SSH Key pair to use for the resources"
  default = "terraform21"
}
variable "ami" {
  type = map(string)
  description = "A MAP of AMIs"
  default = {
      "us-east-1" = "ami-036490d46656c4818"
      "us-east-2" = "ami-044696ab785e77725"
      "us-west-1" = "ami-09bedd705318020ae"
  }
}
variable "instance_type" {
  type = string
  description = "The Instance Size"
  default = "t2.micro"
}
