# Load AWS provider module
module "provider" {
    source = "./modules/provider"
  }
  
  # Load VPC
  module "vpc" {
    source = "./modules/vpc"
  }
  
  # Load Subnets
  module "subnets" {
    source  = "./modules/subnets"
    vpc_id  = module.vpc.vpc_id
  }
  
  # Load Security Groups
  module "security_group" {
    source = "./modules/security_group"
    vpc_id = module.vpc.vpc_id
  }
  
  # Load EC2 instance
  module "ec2" {
    source          = "./modules/ec2"
    security_group  = module.security_group.ec2_sg_id
    subnet_id       = module.subnets.public_subnet_id
    key_name        = var.aws_key_name
    db_username     = var.db_username
    db_password     = var.db_password
    db_endpoint     = module.rds.endpoint
  }
  
  # Load RDS MySQL database
  module "rds" {
    source         = "./modules/rds"
    security_group = module.security_group.rds_sg_id
    subnet_ids     = [module.subnets.private_subnet_id, module.subnets.public_subnet_id]
    db_username    = var.db_username
    db_password    = var.db_password
    db_name        = "wordpress_db"
  }

  terraform {
    backend "s3" {
      bucket         = var.s3_bucket_name # Replace with your actual bucket name
      key            = "terraform/state.tfstate"   # Path inside the bucket
      region         = "us-east-1"                 # Replace with your AWS region
      encrypt        = true                         # Encrypts the state file
    }
  }