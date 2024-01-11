packer {
  required_plugins {
    amazon = {
      version = " >= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "example" {
  ami_name      = "golden image {{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami = "ami-0cd3c7f72edd5b06d"
  ssh_username = "ec2-user"
  ssh_keypair_name = "packer"
  ssh_private_key_file = "~/.ssh/id_rsa"

  run_tags = {
    Name = "kaizen"
  }


# Provide AWS Account numbers to share the AMI with
ami_users = [
    "451294433764",
    "929678616261",
  ]
#   ami_regions = [
#     "us-east-1",
#     "us-west-2",
#     "eu-west-1"
#   ]
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.example"
  ]

  provisioner "shell" {
    script = "script.sh"
  }

  provisioner "breakpoint" {
    note = "Plese verify the image before proceeding"
  }

}