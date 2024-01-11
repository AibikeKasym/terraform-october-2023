terraform {
  backend "s3" {
    bucket = "nagios-group-project.3"
    key    = "ohio/terraform.tfstate"
    region = "us-east-2"
  }
}
