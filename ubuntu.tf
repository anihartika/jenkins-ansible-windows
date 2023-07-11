module "ec2_MCSLAPPUbuntu" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~>3.0"
  user_data = data.template_file.userdata.rendered

  ami = "ami-0d70546e43a941d70"//Replace these valuses
  instance_type = "m6i.large"
  key_name = "my-key-pair" //Replace these values
  security_groups = ["my-security-group"]

  user_data = data.template_file.userdata.rendered

  tags = {
    Name = "my-ec2-instance"
  }

  iam_instance_profile = "my-iam-instance-profile"

  vpc_id = aws_vpc.default.id
  subnet_id = aws_subnet.default.id

  # Attach the IAM role to the instance
  iam_instance_profile_attachment {
    instance_id = module.ec2_instance.id
    iam_instance_profile_arn = aws_iam_role.default.arn
  }
}

data "template_file" "userdata" {
  template = file("userdata.sh")
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16" //Replace these values
}

resource "aws_subnet" "default" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.0.0/24" //Replace these values
}

resource "aws_iam_role" "default" {
  name = "my-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  policy {
    name = "my-iam-role-policy"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
  }
}
