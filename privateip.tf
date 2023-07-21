variable "private_ip" {
  type = string
}

resource "aws_security_group" "allow_private_ip" {
  name = "allow-private-ip"
  vpc_id = aws_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_cidr_blocks = ["10.0.0.10/32"]
  }
}

module "ubuntu" {
  source = "hashicorp/ubuntu/aws"

  ami = "ami-03d8059563982d7b0"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_private_ip.id]
  subnet_id = aws_subnet.default.id

  private_ip = var.private_ip
}

This code will create a security group named allow-private-ip that allows traffic from the private IP address 10.0.0.10 on port 22. The security group ID will be stored in the allow_private_ip.id output variable.

The private_ip variable is used to specify the private IP address of the Ubuntu instance. This variable can be set to a private IP address that is allowed by the allow-private-ip security group.

The security_groups attribute of the module.ubuntu resource is set to the value of the allow_private_ip.id output variable. This means that the Ubuntu instance will be assigned to the security group that was created by the allow-private-ip module.

To call this code, you can use the following command:

terraform apply
This will create the security group and the Ubuntu instance. You will then be able to connect to the instance using the private IP address that is specified by the private_ip variable.
