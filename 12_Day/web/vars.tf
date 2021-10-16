variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "sshprivatekey" {
  description = "private key location"
  default     = "/Users/preetamzare/Documents/Terraform/Private_Data/keys/devops/devops2"
}

variable "sshpublickey" {
  description = "public key location"
  default     = "/Users/preetamzare/Documents/Terraform/Private_Data/keys/devops/devops2.pub"
}

variable "amiids" {
  description = "AMI ID allowed"
  type        = map(any)
  default = {
    "us-east-1" = "ami-036490d46656c4818"
    "us-east-2" = "ami-044696ab785e77725"
    "us-west-1" = "ami-09bedd705318020ae"
  }
}