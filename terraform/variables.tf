########################################
# Module configuration variables
########################################
variable "create" {
  description = "Controls if VPC and networking resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

########################################
# common variables
########################################
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "region" {
  type        = string
  description = "(Required) - Region to deploy the resources to."
}

variable "cluster_name" {
  type        = string
  description = "(Optional) - Name of the created kubernetes cluster."
  default     = "s3-load-test"
}

########################################
# VPC module input variables
########################################
variable "vpc_cidr_block" {
  type        = string
  description = "(Required) - The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden."
}

variable "public_subnet_cidr_block" {
  type        = list(string)
  description = "(Required) - The CIDR block for Public subnet."
}

variable "private_subnet_cidr_block" {
  type        = list(string)
  description = "(Required) - The CIDR block for Private subnet."
}

########################################
# EKS module input variables
########################################
variable "node_pool_configuration" {
  type = list(object({
    name          = string
    min_size      = number
    max_size      = number
    desired_size  = number
    instance_type = string
    taints = list(object({
      key    = string
      value  = any
      effect = string
    }))
    labels = any
  }))
  description = "(Optional) - EKS managed node pool configuration."
  default     = []
}

variable "kubernetes_version" {
  type        = string
  description = "(Optional) - Kubernetes Version to be used."
  default     = "1.27"
}

variable "allow_api_ip_ranges" {
  type        = list(string)
  description = "(Optional) - List of ip ranges, that will be allowed to access the cluster api."
  default     = []
}

variable "deploy_user" {
  type        = string
  description = "(Required) Name of the AWS IAM user used to deploy the cluster. Will be explicitly added to system::master group."
}

variable "vpc_cni_version" {
  type        = string
  description = "(Optional) - AWS VPC CNI Version to be used."
  default     = "v1.15.0-eksbuild.2"
}

########################################
# S3 module input variables
########################################
variable "bucket" {
  type        = string
  description = "Name of the target bucket to perform load test on."
  default     = "apurva-test"
}
