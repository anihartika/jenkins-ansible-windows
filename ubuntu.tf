module "ec2_MCSLAPPUbuntu" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~>3.0"
  user_data = data.template_file.userdata_ubuntu.rendered


resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
}

resource "aws_security_group" "example_sg" {
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_iam_instance_profile" "example_iam_instance_profile" {
  name = "ubuntu-instance-profile"
  role_arn = "arn:aws:iam::<account_id>:role/<role_name>"
}

data "template_file" "user_data_ubuntu" {
  template = <<EOF
#!/bin/bash

sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
}

  ami = "ami-0123456789abcdef0"
  instance_type = "m2i.large"
  monitoring = true
  vpc_id = aws_vpc.example.id //check for vpc section and modify it
  subnet_id = aws_subnet.example_subnet.id //Replace the values
  associated_public_ip_address=true
  security_groups = [aws_security_group.example_sg.id] //replace the values
  iam_instance_profile = aws_iam_instance_profile.example_iam_instance_profile.name //replace the values
  key_name = ubuntu.pem


tags = {
    Name = "example-instance"
  }
}







