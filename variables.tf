# AWS key pair for SSH access to the EC2 instance
variable "aws_key_name" {
    description = "The name of the AWS key pair to use for EC2 instance access"
    type        = string
  }
  
  # Database username for RDS
  variable "db_username" {
    description = "The username for the RDS database"
    type        = string
    sensitive   = true
  }
  
  # Database password for RDS
  variable "db_password" {
    description = "The password for the RDS database"
    type        = string
    sensitive   = true
  }

  variable "s3_bucket_name" {
    description = "The name of the S3 bucket to use for storing the WordPress files"
    type        = string
    sensitive = true
  }