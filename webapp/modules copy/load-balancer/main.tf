resource "aws_lb" "web_alb" {
  name = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [var.allow_http_sec_grp_id]
  subnets = split(",", var.subnet_ids)

  tags = {
    Purpose = "assignment"
  }
}

# Create target groups with basic health check
resource "aws_lb_target_group" "web_tg" {
  name = "${var.project}-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  # lifecycle { create_before_destroy=true }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    port = 80
    protocol = "HTTP"
  }
}

# listener
resource "aws_lb_listener" "web_alb_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# # Create an ASG
# resource "aws_autoscaling_group" "web-asg" {
#   name = "${var.project}-asg"
#   min_size = "1"
#   max_size = "2"
#   launch_configuration = "${aws_launch_configuration.my-app-alb.name}"
#   termination_policies = [
#     "OldestInstance",
#     "OldestLaunchConfiguration",
#   ]
  
#   health_check_type = "ELB"

#   # depends_on = [
#   #   "aws_alb.my-app-alb",
#   # ]

#   target_group_arns = [
#     "${aws_alb_target_group.target-group-1.arn}",
#     "${aws_alb_target_group.target-group-2.arn}",
#   ]

#   lifecycle {
#     create_before_destroy = true
#   }
# }



# resource "aws_lb" "test" {
#   name               = "test-lb-tf"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = [for subnet in aws_subnet.public : subnet.id]

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

#   tags = {
#     Environment = "production"
#   }
# }