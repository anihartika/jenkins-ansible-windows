module "ubuntu_instance" {
  source = "hashicorp/aws/modules/ec2/instance"
  ami = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
  associate_public_ip_address = true
}

output "public_ip" {
  value = module.ubuntu_instance.public_ip
}

resource "aws_security_group" "default" {
  name = "default"
  ingress {
    protocol = "tcp"
    port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_from_public_ip" {
  security_group_id = aws_security_group.default.id
  from_port = 80
  to_port = 80
  cidr_blocks =  ["${output.public_ip}/32"]
}
