terraform {
  backend "s3" {
    bucket = "herabakirova"
    key    = "statefiles/terraform.tfstate"
    region = "us-east-2"
  }
}
