variable "aws_region" {
  default = "us-east-2"
  description = "us-east-2"
}
variable "sshkeysprivate" {
  default = "/Users/preetam_s007/Documents/aws_sshkeys/webuserpvt"
  description = "Private key"
}
variable "sshkeyspublic" {
  default = "/Users/preetam_s007/Documents/aws_sshkeys/webuserpvt.pub"
  description = "Public key"
}