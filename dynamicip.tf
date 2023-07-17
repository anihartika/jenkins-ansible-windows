resource "aws_eip" "dynamic_ip" {
  vpc = true
  depends_on = [aws_instance.my_instance]
  allocation_method = "dynamic"
}

resource "aws_security_group" "my_security_group" {
  name = "my_security_group"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ports = ["22", "80", "443"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = aws_eip.dynamic_ip.*
    content {
      from_port = 80
      to_port = 80
      cidr_blocks = [aws_eip.dynamic_ip.*.public_ip]
    }
  }
}

output "dynamic_ip_address" {
  value = aws_eip.dynamic_ip.0.public_ip
}

output "security_group_id" {
  value = aws_security_group.my_security_group.id
}
