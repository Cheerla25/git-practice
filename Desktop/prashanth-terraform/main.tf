provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "prashanth" {
  ami = var.ami
  instance_type = var.instance_type
}
resource "aws_s3_bucket" "s3-exam" {
  bucket = var.bucket
  tag{
    name = "prashanth"
  }
}
resource "aws_dynamodb_table" "terraform_lock" {
  name          = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}