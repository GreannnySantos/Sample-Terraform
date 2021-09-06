#rq_vpc variables
variable "aws_access_key" {
    type = string
    default = ""
}
variable "aws_secret_key" {
    type = string
    default = ""  
}

#----------------------------------------------subnet variables------------------------------------------------------------#
variable "rq_public_subnets_cidr" {
type    = list 
default = ["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "rq_public_subnets_azs" { 
type    = list
default = ["us-east-1a" , "us-east-1b"] 
}
