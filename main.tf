provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-0e70db31f7e942241"
  instance_type = "t2.micro"
  subnet_id = "subnet-9de57eb6"

  tags = {
      Name = "terraform-example1"
  }
}
