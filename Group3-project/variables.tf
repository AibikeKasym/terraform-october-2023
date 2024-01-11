variable "region" {
  description = "The AWS region"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for the subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  type        = list(string)
}

variable "ami_owner" {
  description = "Owner of the AMI"
}

variable "ami_name_pattern" {
  description = "Name pattern of the AMI"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
}

variable "key_name" {
  description = "Key name for the EC2 instance"
}

variable "public_key_path" {
  description = "Path to the public key"
}