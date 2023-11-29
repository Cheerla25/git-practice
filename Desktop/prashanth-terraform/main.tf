provider "aws" {
    region = us-east-1
  
}
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "prashanth"
  }
}
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Cheerla"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "august"
  }
}
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "ass" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route.id
}
resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web-sg"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrlSuSzteJpDxtRU4o0JS2tfpBcX6gasnZn9Pv3xrH73UxVF/8jkLz40llJxmlgaCHT4x6+ufQ/7arGa4mweDMk7OdfDO0FjFGR6MO+eR9ChE0vayP1NNg8uqrzkxROnn/z9nX7YfNmqxE0eEr/EPGx+4SdqxqYNRuvWHc+6O3QyzlvUy1ZGg8KHHdKcUz7c6EbaGodm9Ayu8jPzuW6cviUO1l2BIGR4KUuKpS132JSCA0UFIWzI3L+YoszVKadVRUaIFNR7bfrOqcZdispWJuTTdr3gaQUy0F5Lh13AB/wIcEi4pL87aswWVXgr39IvYkPuSEXvRUSHF3zJmQYIJG97DUMKLzmzODj5J1ROqenoDiiPbAwhnNj0BOGr3QnTQ5CDymJLplumXh47n+PXfDfvsVN+tIJ7M9FjF990M3dZDHvdqmnoqouXvuKNg8o5xzHY4qvHfIjv8/uSYXBvICCkCmYeu8JDjSS8H/hMK/P1DeKlo1oa0oswaE0UhTPN0= ashok reddy@LAPTOP-BN1UVPL1"
}
resource "aws_instance" "server" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.subnet.id

connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("C:/Users/ASHOK REDDY/.ssh/id_rsa") # Replace with the path to your private key
    host        = self.public_ip
  }
 provisioner "file" {
    source      = "https://github.com/Cheerla25/spring-petclinic-test.git"  # Replace with the path to your local file
    destination = "/home/ubuntu/spring-petclinic-test.git"  # Replace with the path on the remote instance
  }
   provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y git",
      "sudo apt install openjdk-17-jdk -y",
      "sudo apt install maven -y",  # Example package installation
      "cd /home/ubuntu",
      "mvn clean install",
      
    ]
  }
}
