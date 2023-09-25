data "aws_eks_cluster_auth" "k8s" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster" "k8s" {
  name = module.eks_cluster.cluster_id
}

resource "helm_release" "example" {
  name  = "s3-load-test"
  chart = "./../helm"

  # values = [
  #   "${file("values.yaml")}"
  # ]

  set {
    name  = "loadTest.awsRegion"
    value = var.region
  }

  set {
    name  = ".loadTest.target"
    value = module.s3_bucket.id
  }
}
