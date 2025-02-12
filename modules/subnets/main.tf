resource "aws_subnet" "public_subnet" {
    vpc_id                  = var.vpc_id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
  }
  
  resource "aws_subnet" "private_subnet" {
    vpc_id            = var.vpc_id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
  }
  
  resource "aws_internet_gateway" "wordpress_igw" {
    vpc_id = var.vpc_id
  }
  
  resource "aws_route_table" "public_rt" {
    vpc_id = var.vpc_id
  
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.wordpress_igw.id
    }
  }
  
  resource "aws_route_table_association" "public_rta" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
  }