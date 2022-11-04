resource "aws_security_group" "webserver-sg" {
  name        = "${var.project}_webserver-sg"
  description = "Enable HTTP Access"
  vpc_id      = var.vpc_id
}
resource "aws_security_group_rule" "webserver-in" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.webserver-sg.id
  source_security_group_id = aws_security_group.loadbalancer-sg.id
}
#If there is more than one rule for a specific port, Amazon EC2 applies the most permissive rule.
# resource "aws_security_group_rule" "webserver-all-in" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "all"
#   security_group_id = aws_security_group.webserver-sg.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "webserverout" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.webserver-sg.id
# }
resource "aws_security_group_rule" "webserverout" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webserver-sg.id
}
resource "aws_security_group_rule" "webserverout443" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webserver-sg.id
}
resource "aws_security_group" "loadbalancer-sg" {
  name        = "${var.project}_loadbalancer-sg"
  description = "Enable HTTP Access"
  vpc_id      = var.vpc_id
}
resource "aws_security_group_rule" "loadbalancerin" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.loadbalancer-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "loadbalancerout" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # cidr_blocks       = ["0.0.0.0/0"]
  source_security_group_id = aws_security_group.webserver-sg.id
  security_group_id = aws_security_group.loadbalancer-sg.id
}
# resource "aws_security_group" "allow-ssh" {
#   name        = "${var.project}-allow-ssh"
#   description = "Enable SSH Access"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "SSH Access"
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
# resource "aws_security_group" "jenkins-sg" {
#   name        = "${var.project}_jenkins-sg"
#   description = "Enable HTTP Access"
#   vpc_id      = var.vpc_id
# }
# #If there is more than one rule for a specific port, Amazon EC2 applies the most permissive rule.
# resource "aws_security_group_rule" "jenkinsin8080" {
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   security_group_id = aws_security_group.jenkins-sg.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }
# resource "aws_security_group_rule" "jenkinsin22" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   security_group_id = aws_security_group.jenkins-sg.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }
# # resource "aws_security_group_rule" "jenkinsout" {
# #   type              = "egress"
# #   from_port         = 0
# #   to_port           = 65535
# #   protocol          = "tcp"
# #   cidr_blocks       = ["0.0.0.0/0"]
# #   security_group_id = aws_security_group.jenkins-sg.id
# # }
# resource "aws_security_group_rule" "jenkinsout" {
#   type              = "egress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.jenkins-sg.id
# }
# resource "aws_security_group_rule" "jenkinsout443" {
#   type              = "egress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.jenkins-sg.id
# }