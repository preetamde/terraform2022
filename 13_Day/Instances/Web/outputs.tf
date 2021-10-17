# output for the instance
output "publicip" {
  value =aws_instance.webinstance.public_ip
  description = "Public IP for the instance"
}