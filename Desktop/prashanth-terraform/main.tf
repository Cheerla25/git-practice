terraform {
  provider "aws"{
   region "us-east-1"
  }
  resource "aws_instance" "prashanth"{
    ami = ""
    instance_type = ""
  }
}