terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}


variable "number_example" {
  description = "An example of a number variable in Terraform"
  type        = number
  default     = 42
}

variable "list_example" {
  description = "An example of a list in terraform"
  type        = list
  default     = ["a", "b", "c"]
}

variable "map_example" {
  description = "An example of a map in Terraform"
  type        = map(string)
  default     = {
    key1      = "value1"
    key2      = "value2"
    key3      = "value3"
  } 
}

variable "object_example" {
  description = "An example of a structural type in Terraform"
  type        = object({
    name      = string
    age       = number
    tags      = list(string)
    enabled   = bool
  })
  default     = {
    name      = "value1"
    age       = 42
    tags      = ["a", "b", "c"]
    enabled   = true
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "app_server" {
  ami                    = "ami-830c94e3"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello,World" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF


  tags = {
    Name = "ExampleAppServerInstance"
  }
}

