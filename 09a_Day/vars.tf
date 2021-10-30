variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  description = "AWS Region for this module"
  default = "us-east-2"
}
variable "AMIS" {
  description = "Ubuntu AMIs specific to region"
  type = map
  default = {
      "us-east-1" = "ami-036490d46656c4818"
      "us-east-2" = "ami-044696ab785e77725"
  }
}

variable "sshpubkey" {
  description = "SSH Keys for the instance"
  default = "/Users/preetam_s007/Documents/aws_sshkeys/webuserpvt.pub"
}

variable "sshpvtkey" {
  description = "SSH Pvt key location"
  default = "/Users/preetam_s007/Documents/aws_sshkeys/webuserpvt"
}