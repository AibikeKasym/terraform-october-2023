# Provider block
provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "group_3_vpc" {
  cidr_block = var.vpc_cidr_block
  
  tags = {
    Name = "group-3"
  }
}

# Create Internet Gateway and attach it to VPC  
resource "aws_internet_gateway" "group_3_igw" {
  vpc_id = aws_vpc.group_3_vpc.id

  tags = {
    Name = "group-3-igw"
  }
}

# Create 3 subnets
resource "aws_subnet" "group_3_subnet_1" {
  vpc_id = aws_vpc.group_3_vpc.id
  cidr_block = var.subnet_cidr_blocks[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "Group-3-Subnet-1"
  }
}

resource "aws_subnet" "group_3_subnet_2" {
  vpc_id = aws_vpc.group_3_vpc.id
  cidr_block = var.subnet_cidr_blocks[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "Group-3-Subnet-2" 
  }
}

resource "aws_subnet" "group_3_subnet_3" {
  vpc_id = aws_vpc.group_3_vpc.id
  cidr_block = var.subnet_cidr_blocks[2]
  availability_zone = var.availability_zones[2]

  tags = {
    Name = "Group-3-Subnet-3"
  }
}

# Create route table and add public route
resource "aws_route_table" "group_3_public_rt" {
  vpc_id = aws_vpc.group_3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.group_3_igw.id
  }

  tags = {
    Name = "Group-3-Public-RT"
  }
}

# Associate subnets with route table
resource "aws_route_table_association" "group_3_rt_assoc_1" {
  subnet_id = aws_subnet.group_3_subnet_1.id
  route_table_id = aws_route_table.group_3_public_rt.id
}

resource "aws_route_table_association" "group_3_rt_assoc_2" {
  subnet_id = aws_subnet.group_3_subnet_2.id
  route_table_id = aws_route_table.group_3_public_rt.id
}

resource "aws_route_table_association" "group_3_rt_assoc_3" {
  subnet_id = aws_subnet.group_3_subnet_3.id
  route_table_id = aws_route_table.group_3_public_rt.id
}

# Create security group 
resource "aws_security_group" "group_3_sg" {
  name = "group-N3"
  description = "Allow traffic for Nagios"
  vpc_id = aws_vpc.group_3_vpc.id

  # Allow SSH  
  ingress {
    description = "Allow SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP for Nagios
  ingress {
    description = "Allow HTTP for Nagios"  
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance 
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  subnet_id     = aws_subnet.group_3_subnet_1.id
  vpc_security_group_ids = [aws_security_group.group_3_sg.id]

  tags = {
    Name = "Group-3-Instance"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "my_key_namea"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "null_resource" "install_nagios" {
  # Trigger re-provisioning when the instance id changes
  triggers = {
    instance_id = aws_instance.example.id
  }

  # Connection details for SSH
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa.pub")
    host        = aws_instance.example.public_ip
  }

  # Provisioner block
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nagios3"
    ]
  }
}