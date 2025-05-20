

#target group for alb
resource "aws_lb_target_group" "rq_target_group" {
  name         = "rq-target-group"
  port         = 80
  protocol     = "HTTP"
  vpc_id       = aws_vpc.rq_vpc.id
  
}

resource "aws_lb_target_group_attachment" "rq_target_group_attachment" {
  target_group_arn = aws_lb_target_group.rq_target_group.arn
  target_id        = aws_instance.rq_private_ec2.id
  port             = 80
}


#create application load balancer
resource "aws_lb" "rq_alb" {
  name               = "rq-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rq_public_alb_sg.id]
  subnets            = aws_subnet.rq_public_subnets.*.id
  enable_deletion_protection = true

  tags = {
    Name       = "aws_lb.rq_alb"
    Project    = "rearc_quest"
  }
}


 #----------------------------------------ALB listeners------------------------------------------------------------------------------#
 
#adding listeners HTTPS listener to alb
resource "aws_lb_listener" "rq_alb_https_listener" {
  load_balancer_arn = aws_lb.rq_alb.arn
  port               = 443
  protocol           = "HTTPS"
  certificate_arn    = "arn:aws:acm:us-east-1:244740059957:certificate/dac36f7b-f516-4a4b-8e87-e0d5d83d056d"


#forwarding 443 traffic to target group
 default_action {
  target_group_arn = aws_lb_target_group.rq_target_group.arn
  type = "forward"
  }
 }
  
#adding listeners HTTP listener to alb
resource "aws_lb_listener" "rq_alb_http_listener" {
  load_balancer_arn = aws_lb.rq_alb.arn
  port              = "80"
  protocol          = "HTTP"

#redirecting port 80 traffic as 443 to target group
default_action {
  type = "redirect"

redirect {
  port        = "443"
  protocol    = "HTTPS"
  status_code = "HTTP_301"
   }
  }
}
