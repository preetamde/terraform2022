# 1. S3 Resource

resource "aws_s3_bucket" "s3backend" {
  bucket = "terraformbackend111021"
  versioning {
    enabled = true
  }
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    lifecycle {
     prevent_destroy = true 
  }
  
}

# 2. DynamoDB Table

resource "aws_dynamodb_table" "s3backendtable" {
  name = "s3backendtable"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# 3. Backend. Remember this is one time activity only

terraform {
  backend "s3" {
      bucket = "terraformbackend111021"
      key = "global/s3/terraform.tfstate"
      dynamodb_table = "s3backendtable"
      profile = "terraform"
      region = "us-east-2"
      encrypt = true

  }
}

output "s3backendoutput" {
  value = aws_s3_bucket.s3backend.arn
}

output "dyndboutput" {
  value = aws_dynamodb_table.s3backendtable.name
}
