provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "prashanth" {
  ami = var.ami
  instance_type = var.instance_type
}