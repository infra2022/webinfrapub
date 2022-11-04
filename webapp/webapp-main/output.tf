output "load_balancer_address" {
  value       = module.web_load_balancer.load_balancer_address
  description = "The DNS name for the Web Load Balancer."
}
output "private_vpcs_ids" {
  value       = module.vpc.private_subnets_ids
  description = "The VPC Sunbets Data."
}
output "public_vpcs_ids" {
  value       = module.vpc.public_subnets_ids
  description = "The VPC Sunbets Data."
}
