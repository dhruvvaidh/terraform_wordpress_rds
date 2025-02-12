data "aws_ami" "amazon_linux_2023" {
  most_recent = true    # Get the latest version of the AMI
  owners      = ["amazon"]  # Only accept Amazon-owned AMIs

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]  # Filter for Amazon Linux 2023 AMIs
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]  # Hardware Virtual Machine AMIs only
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]  # EBS-backed instances only
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]  # 64-bit x86 architecture only
  }
}

resource "aws_instance" "wordpress_ec2" {
    ami                    = data.aws_ami.amazon_linux_2023.id 
    instance_type          = "t2.micro"
    subnet_id              = var.subnet_id
    vpc_security_group_ids = [var.security_group]
    key_name               = var.key_name
  
    user_data = templatefile("wp_rds_install.sh", {
      db_name = var.db_name
      db_username = var.db_username
      db_password = var.db_password
      db_endpoint = var.db_endpoint
    })
  }