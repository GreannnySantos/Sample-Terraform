#application load balancer security group
resource "aws_security_group" "rq_public_alb_sg" {  
 vpc_id = aws_vpc.rq_vpc.id
 name   = "rq_public_alb_sg"
 
    tags = {
    Name       = "rq_public_alb_sg"
    Project    = "rearc_quest"
  }
}


resource "aws_security_group_rule" "rq_public_alb_sg0_rule" { 
      type             = "ingress"
      description      = "TLS from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      security_group_id  = aws_security_group.rq_public_alb_sg.id
    }


resource "aws_security_group_rule" "rq_public_alb_sg1_rule" { 
       type          = "ingress"
       from_port     = 80
       to_port       = 80
       protocol      = "tcp"
       cidr_blocks   = ["0.0.0.0/0"]
       security_group_id  = aws_security_group.rq_public_alb_sg.id
    }
  
resource "aws_security_group_rule" "rq_public_alb_sg2_rule" { 
       type                 = "egress"
       from_port            = 80
       to_port              = 80
       protocol             = "tcp"
       source_security_group_id   = aws_security_group.rq_private_ec2_sg.id
       security_group_id          = aws_security_group.rq_public_alb_sg.id
}



#----------------------------------------------ec2 sg------------------------------------------------------------#

#ec2 security group
resource "aws_security_group" "rq_private_ec2_sg" {  
 vpc_id = aws_vpc.rq_vpc.id
 name = "rq_private_ec2_sg"



    tags = {
    Name       = "rq_private_ec2_sg"
    Project    = "rearc_quest"
  }
}



resource "aws_security_group_rule" "rq_private_ec2_sg0_rule" { 
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id   = aws_security_group.rq_public_alb_sg.id
  security_group_id          = aws_security_group.rq_private_ec2_sg.id
}

resource "aws_security_group_rule" "rq_private_ec2_sg1_rule" { 
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rq_private_ec2_sg.id
}



  