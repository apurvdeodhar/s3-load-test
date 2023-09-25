<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | terraform-aws-modules/eks/aws | ~> 18.0 |
| <a name="module_log_bucket"></a> [log\_bucket](#module\_log\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.15.1 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.15.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_cluster_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group_rule.eks_node_to_node_tcp_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.eks_node_to_node_tcp_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [helm_release.example](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.k8s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.k8s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_api_ip_ranges"></a> [allow\_api\_ip\_ranges](#input\_allow\_api\_ip\_ranges) | (Optional) - List of ip ranges, that will be allowed to access the cluster api. | `list(string)` | `[]` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Name of the target bucket to perform load test on. | `string` | `"apurva-test"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Optional) - Name of the created kubernetes cluster. | `string` | `"s3-load-test"` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if VPC and networking resources should be created (affects nearly all resources) | `bool` | `true` | no |
| <a name="input_deploy_user"></a> [deploy\_user](#input\_deploy\_user) | (Required) Name of the AWS IAM user used to deploy the cluster. Will be explicitly added to system::master group. | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (Optional) - Kubernetes Version to be used. | `string` | `"1.27"` | no |
| <a name="input_node_pool_configuration"></a> [node\_pool\_configuration](#input\_node\_pool\_configuration) | (Optional) - EKS managed node pool configuration. | <pre>list(object({<br>    name          = string<br>    min_size      = number<br>    max_size      = number<br>    desired_size  = number<br>    instance_type = string<br>    taints = list(object({<br>      key    = string<br>      value  = any<br>      effect = string<br>    }))<br>    labels = any<br>  }))</pre> | `[]` | no |
| <a name="input_private_subnet_cidr_block"></a> [private\_subnet\_cidr\_block](#input\_private\_subnet\_cidr\_block) | (Required) - The CIDR block for Private subnet. | `list(string)` | n/a | yes |
| <a name="input_public_subnet_cidr_block"></a> [public\_subnet\_cidr\_block](#input\_public\_subnet\_cidr\_block) | (Required) - The CIDR block for Public subnet. | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | (Required) - Region to deploy the resources to. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | (Required) - The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden. | `string` | n/a | yes |
| <a name="input_vpc_cni_version"></a> [vpc\_cni\_version](#input\_vpc\_cni\_version) | (Optional) - AWS VPC CNI Version to be used. | `string` | `"v1.15.0-eksbuild.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_crt"></a> [cluster\_ca\_crt](#output\_cluster\_ca\_crt) | EKS cluster ca cert. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | EKS cluster endpoint. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | EKS cluster id. |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets. |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets. |
| <a name="output_region"></a> [region](#output\_region) | AWS region name being used. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC. |
<!-- END_TF_DOCS -->