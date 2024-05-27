# Creation of the load balancer
resource "aws_lb" "public_lb" {
  name = "public-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.public_sg.id]
  subnets = aws_subnet.public_subnet[*].id

  tags = {
    Name = "public_lb"
  }
}

# Defining targets
resource "aws_lb_target_group" "public_tg" {
  name = "public-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id

  health_check {
    interval =  30
    path = "/"
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200-299"
  }

  tags = {
    Name = "public_tg"
  }
}

# Defining Listeners
resource "aws_lb_listener" "public_lb_listener" {
  load_balancer_arn = aws_lb.public_lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.public_tg.arn
  }
}
