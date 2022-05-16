provider "aws" {
  profile = "lab_user"
  region = "ap-southeast-1"
}

resource "aws_security_group" "terraform-ec2-sg" {
  name = "terraform-ec2-sg"
  description = "Security Group for Terraform EC2 Instance"
  //vpc_id = [specific_vpc_id]
}

resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform-ec2-sg.id
}

resource "aws_security_group_rule" "public_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform-ec2-sg.id
}

resource "aws_security_group_rule" "public_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform-ec2-sg.id
}

resource "aws_security_group_rule" "public_in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform-ec2-sg.id
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "ec2-example-key"
  public_key = tls_private_key.example.public_key_openssh
  
  //save key into local pc
  provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
    command = "echo ${tls_private_key.example.private_key_openssh} >> ec2-example-key.pem"
  }
  
  depends_on = [ 
    tls_private_key.example
  ]
}

resource "aws_instance" "terraform_ec2_example" {
  ami           = "ami-0bd6906508e74f692"
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform EC2"
    Environment = "DEV"
    OS = "Amazon Linux"
  }
  
  root_block_device {
    delete_on_termination = true
    volume_size = "8"
    volume_type = "gp2"
    encrypted = true
  }
  
  key_name = aws_key_pair.generated_key.key_name

  vpc_security_group_ids = [
    aws_security_group.terraform-ec2-sg.id
  ]
  
  provisioner "local-exec" {
    command = "echo public IP address: ${aws_instance.terraform_ec2_example.public_ip} >> public_ip_address.txt"
  }

  depends_on = [ 
    aws_security_group.terraform-ec2-sg,
    aws_key_pair.generated_key
  ]
}

output "ec2instance" {
  value = aws_instance.terraform_ec2_example.public_ip
}
