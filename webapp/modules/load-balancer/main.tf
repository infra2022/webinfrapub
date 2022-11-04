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
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 40
    port = 80
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group" "jk_tg" {
  name = "${var.project}-jk-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_id

  # lifecycle { create_before_destroy=true }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 40
    port = 8080
    protocol = "HTTP"
  }
}
# listener
resource "aws_lb_listener" "web_alb_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
resource "aws_lb_listener" "jk_alb_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jk_tg.arn
  }
}