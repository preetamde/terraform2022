variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
 default = "us-east-2" 
}

variable "amiid" {
  description = "AMI ID Map in three regions"
  type = map
  default = {
      "us-east-1" = "ami-036490d46656c4818"
      "us-east-2" = "ami-044696ab785e77725"
      "us-west-1" = "ami-09bedd705318020ae"
  }
}

variable "public_key" {
  description = "Public key location"
  default = "/Users/preetam_s007/Documents/aws_sshkeys/webuserpvt.pub"
}

variable "private_key" {
  description = "private key location"
  default = "/Users/preetam_s007/Documents/aws_sshkeys/webuserpvt"
}