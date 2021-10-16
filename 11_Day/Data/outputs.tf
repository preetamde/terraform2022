output "dbarn" {
  value = aws_db_instance.dbinstance.arn
  description = "arn of DB"
}

output "dbstring" {
  value = aws_db_instance.dbinstance.endpoint
}