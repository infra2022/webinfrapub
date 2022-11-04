resource "aws_launch_template" "web_lt" {
  name = "${var.project}-${var.name}-lt"
  key_name = "dev-access-pem"
  image_id                    = var.ami
  instance_type               = var.instance_type
  user_data = filebase64(var.startup_script)

  network_interfaces {
    associate_public_ip_address = var.add_public_ip
    security_groups      = [var.allow_http_sec_grp_id]
  }
}
resource "aws_autoscaling_group" "web_autoscaling" {
  name = "${var.project}-${var.name}-asg"
  min_size = var.instance_count_min
  max_size = var.instance_count_max
  health_check_type = "EC2"
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [ var.tg_arn ]

  vpc_zone_identifier =  split("," , var.subnet_ids)

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-webserver-asg"
    propagate_at_launch = true
  }
}

