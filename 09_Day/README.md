# Things to remember

*Date*: 10.10.2021
--- 

1. There is terraform block. It has backend block and this backend block needs a supported backend. e.g. S3
   1. in case of S3 here is how it looks
      1. Bucket name (bucket)
      2. Object location via key attribute (key)
      3. Define region (region)
      4. Define encryption (encrypt), this is over and above S3 encryption
   2. You need DynamoDB table
      1. dynamodb table name (dynamodb_table)
   3. AWS Profile
      1. It is important to provide aws profile name because you cannot use variable in this block. I always prefer to have multiple profiles based on the environment and therefore I will always create a AWS profile with name 

## DynamoDB tables parameters

1. Name of the table (name)
2. How do you want to charge (billingmode)
   1. PROVISIONING (default)
   2. PAY_PER_REQUEST
3. Primary key (referred as hash_key)
   1. it must be LockID (L caps and ID caps)
4. Attribute
   1. name of the attribute. Same as LockID (?)
   2. type of the attribute. It is referred as "S" = Strings

## S3 Bucket parameters

1. Name of the Bucket. (name)
2. Enable versioning (versioning {})
3. Lifecycle to stop S3 being destroyed (! remember, terraform uses destroy word for deleting)
   1. prevent_destroy = true
4. enable encryption (default provided by S3)
   1. server side encryption
      1. rule 
         1. sse_algorithm = AES256
