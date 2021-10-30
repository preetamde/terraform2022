resource "aws_db_instance" "dbinstance" {
  engine = "mysql"
  identifier_prefix = "dbinstance"
  instance_class = "db.t2.micro"
  allocated_storage = "10"
  username = "admin"
  password = var.dbpassword
  skip_final_snapshot = true # if you skip this, terraform destroy fails.
}