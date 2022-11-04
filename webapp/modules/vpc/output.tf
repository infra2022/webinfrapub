output "private_subnet_count" {
  value = "${length(var.private_subnets_cidr)}"
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnets_ids" {
  value = join(",", aws_subnet.private_subnets[*].id)
}
output "public_subnets_ids" {
  value = join(",", aws_subnet.public_subnets[*].id)
}