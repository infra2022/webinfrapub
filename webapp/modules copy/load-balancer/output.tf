output "load_balancer_address" {
  value = aws_lb.web_alb.dns_name
}

output "load_balancer_id" {
  value = aws_lb.web_alb.id
}


output "tg_grp_arn" {
  value = aws_lb_target_group.web_tg.arn
}
