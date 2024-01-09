resource "aws_instance" "web" {
  ami           = "ami-0ee4f2271a4df2d7d"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

