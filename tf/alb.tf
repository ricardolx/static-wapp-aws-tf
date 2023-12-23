resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Security group for the Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb" "webapp_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

#   enable_deletion_protection = true

  tags = {
    Name = "my-lb"
  }
}

# Application Load Balancers
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.webapp_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "80"
      protocol    = "HTTP"
      status_code = "HTTP_301"
      host        =  aws_s3_bucket.bucket.bucket_regional_domain_name
    }
  }

  depends_on = [aws_s3_bucket.bucket]
}