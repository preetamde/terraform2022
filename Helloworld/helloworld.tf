# here is the first script to create a resource in AWS. I called it Hello AWS
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "devopsuser" {
    name = "devpnq"
    tags = {
      "Description" = "first devops user"
    }
  
}

resource "aws_iam_policy" "devopspolicy" {
    name = "Adminusers"
    policy = file("adminpolicy.json")
  
}

resource "aws_iam_user_policy_attachment" "devopspolicyattachment" {
    user = aws_iam_user.devopsuser.name
    policy_arn = aws_iam_policy.devopspolicy.arn
  
}