
#create private subnet
resource "aws_subnet" "rq_private_subnet" {
  availability_zone   = "us-east-1a"
  cidr_block          = "10.0.3.0/24"
   vpc_id             = aws_vpc.rq_vpc.id
  
  tags = {
    Name        = "rq_private_subnet"
    Project     = "rearc_quest"
  }
}


#----------------------------------------------route table------------------------------------------------------------#
resource "aws_route_table" "rq_private_route_table" {
  vpc_id = aws_vpc.rq_vpc.id

   tags = {
    Name = "rq_private_route_table"
  }
}

#create private route table Route to nat gateway
resource "aws_route" "rq_private_route_table_routes" {
  route_table_id            = aws_route_table.rq_private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.rq_nat_gateway.id
}


#private route table and private subnet association
resource "aws_route_table_association" "rq_private_subnet_association" {
  subnet_id              = aws_subnet.rq_private_subnet.id
  route_table_id         =  aws_route_table.rq_private_route_table.id
}
