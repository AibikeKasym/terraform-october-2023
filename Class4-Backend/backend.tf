terraform {
  backend "s3" {
    bucket = "hello-aibike-kaizen"
    key    = "ohio/terraform.tfstate"
    region = "us-east-2"
  }
}
