# Create the users
resource "aws_iam_user" "Aibike2" {
  name = "Aibike2"
}

resource "aws_iam_user" "Kaizen" {
  name = "Kaizen"
}

resource "aws_iam_user" "Hello" {
  name = "Hello"
}

resource "aws_iam_user" "World" {
  name = "World"
}

# Create the groups
resource "aws_iam_group" "DevOps" {
  name = "DevOps"
}

resource "aws_iam_group" "QA" {
  name = "QA"
}

# Add users to groups
resource "aws_iam_group_membership" "devops_users" {
  name = "devops_users"

  users = [
    aws_iam_user.Aibike2.name,
    aws_iam_user.Kaizen.name,
  ]

  group = aws_iam_group.DevOps.name
}

resource "aws_iam_group_membership" "qa_users" {
  name = "qa_users"

  users = [
    aws_iam_user.Hello.name,
    aws_iam_user.World.name,
  ]

  group = aws_iam_group.QA.name
}

# Import the admin user
resource "aws_iam_user" "admin" {
  name = "admin"
}

# Declare the outputs
output "Aibike2_user" {
  value = aws_iam_user.Aibike2
}

output "Kaizen_user_id" {
  value = aws_iam_user.Kaizen.unique_id
}

# Import the S3 buckets
resource "aws_s3_bucket" "bucket1" {
  bucket = "hm-terraform001"
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "hm-terraform002"
}