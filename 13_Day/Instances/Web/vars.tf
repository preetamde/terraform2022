variable "AWS_REGION" {
  default = "us-east-2"
  description = "default region"
}

variable "privatekey" {
  default = "/Users/preetam_s007/Documents/aws_sshkeys/webuserpvt"
  description = "Private key location"
}

variable "publickey" {
    default = "/Users/preetam_s007/Documents/aws_sshkeys/webuserpvt.pub"
  description = "public Key location"
}

variable "az-a" {
  description = "define AZ in my case us-east-2a"
  default = "us-east-2a"
}