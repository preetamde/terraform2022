variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION" {
    default = "us-east-2"
    description = "AWS default region"
}

variable "dbpassword" {
  description = "db master password"
  type = string
  sensitive = true
}