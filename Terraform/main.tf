provider "aws" {
  profile    = "default"
  region     = "ap-southeast-1"
}

resource "aws_security_group" "terraform-ec2-sg" {
  name = "terraform-ec2-sg"
  description = "Security Group for Terraform EC2 Instance"
  vpc_id = "vpc-01dfe2a13a2283c94"

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = ""
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "terraform_ec2_example" {
  ami           = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform EC2"
    Environment = "DEV"
    OS = "Amazon Linux"
  }

  vpc_security_group_ids = [
    aws_security_group.terraform-ec2-sg.id
  ]

  root_block_device {
    delete_on_termination = true
    iops = 150
    volume_size = 50
    volume_type = "gp2"
  }

  depends_on = [ aws_security_group.terraform-ec2-sg ]
}

output "ec2instance" {
  value = aws_instance.terraform_ec2_example.public_ip
}
