# Get AWS account ID
data "aws_caller_identity" "current" {}

# Get current region
data "aws_region" "current" {}

locals {
  # Extend cluster security group rules to enable http and https traffic from specific IP on eks control plane.
  cluster_security_group_additional_rules = {
    ingress_https = {
      description                = "EKS Cluster allows 443 port to get API call"
      type                       = "ingress"
      from_port                  = 443
      to_port                    = 443
      protocol                   = "TCP"
      cidr_blocks                = var.allow_api_ip_ranges
      source_node_security_group = false
    }
    ingress_http = {
      description                = "EKS Cluster allows 80 port to get API call"
      type                       = "ingress"
      from_port                  = 80
      to_port                    = 80
      protocol                   = "TCP"
      cidr_blocks                = var.allow_api_ip_ranges
      source_node_security_group = false
    }
  }

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.deploy_user}"
      username = var.deploy_user
      groups   = ["system:masters"]
    }
  ]
  tags = var.tags

  ########################################
  # EKS node pool locals
  ########################################
  node_pool_configuration = coalescelist(var.node_pool_configuration, local.node_pool_configuration_defaults)
  node_pool_configuration_defaults = [
    {
      name           = "application"
      min_size       = 0
      max_size       = 5
      desired_size   = 1
      instance_types = ["t3.small"] # 2vCPU 1GiB # Micro allows only 4 pods per Node
      taints = {
        dedicated = {
          key    = "application"
          value  = true
          effect = "NO_SCHEDULE"
        }
      }
      labels = {
        "node-type" = "application",
      }
      tags = {
        "k8s.io/cluster-autoscaler/enabled"                         = true,
        "k8s.io/cluster-autoscaler/${module.cluster.cluster_id}"    = "owned",
        "k8s.io/cluster-autoscaler/node-template/taint/application" = true,
        "k8s.io/cluster-autoscaler/node-template/label/node-type"   = "application"
      }
    }
  ]
}

resource "aws_kms_key" "eks" {
  description  = "EKS Secret Encryption Key"
  multi_region = false
}

module "cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  cluster_endpoint_private_access         = false
  cluster_endpoint_public_access          = true
  cluster_endpoint_public_access_cidrs    = var.allow_api_ip_ranges
  cluster_security_group_additional_rules = local.cluster_security_group_additional_rules
  node_security_group_additional_rules = {
    ingress_nginx_8443 = {
      description                   = "Allows master nodes access to port 8443/tcp on worker nodes"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
    egress_http = {
      description = "Allows worker nodes to connect to Internet via http"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  cluster_enabled_log_types = ["audit", "api"]

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

  enable_irsa = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = var.vpc_cni_version
    }
  }

  vpc_id     = toset(module.vpc[*].vpc_id)
  subnet_ids = toset(module.vpc[*].private_subnets)

  create_iam_role = false
  iam_role_arn    = aws_iam_role.eks_cluster_role.arn
  iam_role_additional_policies = {
    s3_access = aws_iam_policy.policy.arn
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_users = local.aws_auth_users

  eks_managed_node_group_defaults = {
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 40
          volume_type           = "gp3"
          delete_on_termination = true
          encrypted             = true
        }
      }
    }
  }

  eks_managed_node_groups = {
    for node_pool in local.node_pool_configuration : node_pool.name => {
      min_size     = node_pool.min_size
      max_size     = node_pool.max_size
      desired_size = node_pool.desired_size

      instance_types = node_pool.instance_types

      taints = node_pool.taints

      labels = node_pool.labels
      tags   = try(node_pool.tags, null)
    }
  }
}

# As of now EKS module does not support to referencing `cluster_security_group_id` as a value to `security_group_id`.
# So after cluster creation we add these rules to `module.cluster_security_group_id`. This will allow node to node tcp traffic.
resource "aws_security_group_rule" "eks_node_to_node_tcp_ingress" {
  description       = "Allows all TCP communication between nodes"
  from_port         = 0
  protocol          = "tcp"
  security_group_id = module.cluster.node_security_group_id
  self              = true
  to_port           = 65535
  type              = "ingress"
}

# Allows all egress traffic on worker nodes.
resource "aws_security_group_rule" "eks_node_to_node_tcp_egress" {
  description       = "Enables all outbound traffic on worker nodes"
  from_port         = 0
  protocol          = "-1"
  security_group_id = module.cluster.node_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  type              = "egress"
}
