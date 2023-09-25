terraform {
  # backend "s3" {
  #   bucket         	   = "mycomponents-tfstate"
  #   key              	   = "state/terraform.tfstate"
  #   region         	   = "eu-central-1"
  #   encrypt        	   = true
  #   dynamodb_table = "mycomponents_tf_lockid"

  backend "local" {
    path = "terraform.tfstate"
  }
  required_version = ">=0.15"

  required_providers {
    # The AWS provider is used to configure your AWS infrastructure.
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.k8s.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.k8s.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_id]
    }
  }
}
