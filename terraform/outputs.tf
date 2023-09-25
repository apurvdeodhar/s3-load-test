########################################
# Common outputs
########################################
output "region" {
  value       = data.aws_region.current.name
  description = "AWS region name being used."
}

########################################
# VPC outputs
########################################
output "vpc_id" {
  value       = toset(module.vpc[*].vpc_id)
  description = "The ID of the VPC."
}

output "private_subnets" {
  value       = toset(module.vpc[*].private_subnets)
  description = "List of IDs of private subnets."
}

output "public_subnets" {
  value       = toset(module.vpc[*].public_subnets)
  description = "List of IDs of public subnets."
}

########################################
# EKS outputs
########################################
output "cluster_id" {
  value       = module.cluster.cluster_id
  description = "EKS cluster id."
}

output "cluster_ca_crt" {
  sensitive   = true
  value       = module.cluster.cluster_certificate_authority_data
  description = "EKS cluster ca cert."
}

output "cluster_endpoint" {
  value       = module.cluster.cluster_endpoint
  description = "EKS cluster endpoint."
}
