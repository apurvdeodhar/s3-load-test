# Get Az's
data "aws_availability_zones" "azs" {
  state = "available"
}

# Locals
locals {
}

# VPC module
module "vpc" {
  count   = var.create ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.cluster_name
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.azs.zone_ids
  private_subnets = var.private_subnet_cidr_block
  public_subnets  = var.public_subnet_cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = var.tags

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }
}
