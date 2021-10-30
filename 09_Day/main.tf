# 1. create a S3 bucket for storing state files and migrate state to the S3 Bucket.
resource "aws_s3_bucket" "s3bkttfs" {
  bucket = "23072021terraformunr"

# prevent accidental deletion of this bucket
    lifecycle {
        prevent_destroy = true
    }
# enable version
    versioning {
    enabled = true
    }
# enable encryption
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default{ 
                sse_algorithm = "AES256"
            }
            bucket_key_enabled = true # to use S3 Bucket keys for SSE-MKS
        }
    }
}

#2. Dynamo DB Table for storing LockID

resource "aws_dynamodb_table" "lockidtable" {
  name = "lockidtable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# terraform config to store state
terraform { # variables are not allowed in this block
  backend "s3" {
    bucket = "23072021terraformunr"
    key = "global/s3/terraform.tfstate"
    dynamodb_table = "lockidtable"
    encrypt = true
    region = "us-east-2"
    profile = "terraform"

  }
}

output "bucketarn" {
  
  value = aws_s3_bucket.s3bkttfs.arn
  description = "ARN of the bucket"
}

output "tablename" {
  value = aws_dynamodb_table.lockidtable.name
  description = "Table Name"
}

output "bucketregion" {
  value = aws_s3_bucket.s3bkttfs.region
}

# * do not use this because it is really slow at this stage.
# AWS Keys needs to available in the environment. I have created a profile with name terraform but it does not work. It searches for default profile.
# finally I decided to exported them via export but this is not a permanent solution.
# ! found it. Profile was added with the name. see like ! 44