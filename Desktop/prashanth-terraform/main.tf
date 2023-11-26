terraform {
  provider "aws"{
   region "aws-east-1" 
  }
  resource "aws_instance" "prashanth"{
    ami = ""
    instance_type = ""
  }
}