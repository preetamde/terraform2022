output "instanceid" {
  value = aws_instance.apache.id
}
output "publicip" {
  value = aws_instance.apache.public_ip
}