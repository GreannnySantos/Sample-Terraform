
# Configure the AWS Provider
provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

#----------------------------------------------vpc------------------------------------------------------------#
#Create vpc 
resource "aws_vpc" "rq_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "rq_vpc" 
    Project = "rearc_quest"
  }
}

#----------------------------------------------igw------------------------------------------------------------#
#Create Internet Gateway. Attach vpc.
resource "aws_internet_gateway" "rq_igw" {
  vpc_id = aws_vpc.rq_vpc.id

  tags = {
    Name = "rq_igw"
    Project = "rearc_quest"
  }
}