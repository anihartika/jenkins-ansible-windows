resource "aws_instance" "example" {
  ami           = "ami-xxxxxxxxxxxxxxxxx"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example.id
}

resource "aws_security_group" "example" {
  name_prefix = "example-security-group"
  description = "Example security group for dynamic IP access"

  ingress {
    description = "Allow SSH from dynamic IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_instance.example.public_ip]
  }

  # Add other ingress and egress rules as needed
}

output "dynamic_public_ip" {
  value = aws_instance.example.public_ip
}
