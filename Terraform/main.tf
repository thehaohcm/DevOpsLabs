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

# Creates/manages KMS CMK
resource "aws_kms_key" "terraform_kms_key" {
  description              = "KMS key for terraform lab"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
  enable_key_rotation      = true
  deletion_window_in_days  = 30
}

# # Add an alias to the key
# resource "aws_kms_alias" "this" {
#   name          = "alias/${var.alias}"
#   target_key_id = aws_kms_key.this.key_id
# }

resource "aws_db_instance" "terraform_rds_example" {
  allocated_storage    = 10
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "example"
  password             = "examplepassword"
  parameter_group_name = "default.mysql.rds.example"
  kms_key_id           = aws_kms_key.terraform_kms_key.key_id
  storage_encrypted    = true
  depends_on           = [ 
	  aws_security_group.terraform-ec2-sg,
	  aws_kms_key.terraform_kms_key 
  ]
}

resource "aws_s3_bucket" "terraform_s3bucket_example" {
  bucket = "terraform_s3bucket_example"
  acl    = private
}

output "ec2instance" {
  value = aws_instance.terraform_ec2_example.public_ip
}
