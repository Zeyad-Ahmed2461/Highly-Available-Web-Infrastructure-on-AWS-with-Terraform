# ALB
resource "aws_lb" "alb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.HTTP_SG.id]
  subnets            = [aws_subnet.pub_subnet1.id, aws_subnet.pub_subnet2.id]
  enable_deletion_protection = false
  tags = { Name = "zeyad-alb" }
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name     = "TG-cloudkode"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path     = "/"
    protocol = "HTTP"
  }

  tags = {
     Name = "TG-zeyad"
  }
}

# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
