output "webserver_sec_grp_id" {
  value = aws_security_group.webserver-sg.id
}
output "load_balancer_sec_grp_id" {
  value = aws_security_group.loadbalancer-sg.id
}
output "jenkins_sec_grp_id" {
  value = aws_security_group.jenkins-sg.id
}
