
#create public subnets
resource "aws_subnet" "rq_public_subnets" {
  count               = length(var.rq_public_subnets_azs)
  availability_zone   = element(var.rq_public_subnets_azs , count.index)             #count = # of identical resources
  cidr_block          = element(var.rq_public_subnets_cidr , count.index)           #length = length in given list,map
  vpc_id              = aws_vpc.rq_vpc.id                                           #element = retrieves one element
 
    tags = {                                                                   #create one subnet one at time
    Name = "rq_public_subnets-${count.index+1}"                                #with a diff. tag name per iteration                                                
  }                                            
}

#----------------------------------------------route table------------------------------------------------------------#

resource "aws_route_table" "rq_public_route_table" {
  vpc_id = aws_vpc.rq_vpc.id
   
   tags = {
    Name = "rq_public_route_table"
  }
}
  #public route table route to internet gateway
  resource "aws_route" "public_route_table_routes" {
  route_table_id            = aws_route_table.rq_public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.rq_igw.id
  }


#public route table and public subnets association 
resource "aws_route_table_association" "rq_public_subnets_association" {
  count               = length(var.rq_public_subnets_cidr)
  subnet_id            = element(aws_subnet.rq_public_subnets.*.id , count.index)
  route_table_id       = aws_route_table.rq_public_route_table.id
}



#----------------------------------------------NAT gateway EIP------------------------------------------------------------#

resource "aws_eip" "rq_eip_nat" {
  vpc = true

  tags = {
    Name      = "rq_eip_nat"
    Project   = "rearc_quest"
   }
  }


#----------------------------------------------NAT gateway------------------------------------------------------------#
resource "aws_nat_gateway" "rq_nat_gateway" {
  allocation_id    = aws_eip.rq_eip_nat.id
  subnet_id        = aws_subnet.rq_public_subnets.*.id[0]
  

  tags = {
    Name       = "rq_nat_gateway"
    Project    = "rearc_quest"
   }
}


  