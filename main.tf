provider "aws" {
  profile = "default"
  region = "us-east-2"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP address of the web server"
}



resource "aws_instance" "example" {
  #ami = "ami-09d95fab7fff3776c" # Amazon Linux 2 AMI (HVM) us-east-1
  image = "ami-026dea5602e368e96"  # Amazon Linux 2 AMI (HVM) us-east-2
  instance_type = "t2.micro"
  #subnet_id = "subnet-9de57eb6"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  
  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
      create_before_destroy = true
  }

  tags = {
      Name = "terraform-example1"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
      from_port = var.server_port
      to_port   = var.server_port
      protocol  = "tcp"
      cidr_blocks= ["0.0.0.0/0"]
  }
}

