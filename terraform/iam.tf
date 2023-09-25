resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#########################################
# Single bucket IAM policy
#########################################
resource "aws_iam_policy" "policy" {
  name        = "s3-bucket-policy"
  path        = "/"
  description = "Load test s3-bucket access policy"
  policy      = <<EOF
{
   "Statement": [
      {
            "Action": [
               "s3:GetObject",
               "s3:GetObjectVersion",
               "s3:PutBucketVersioning",
               "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
               "${module.s3_bucket.s3_bucket_arn}",
               "${module.s3_bucket.s3_bucket_arn}/*"
            ]
      }
   ],
   "Version": "2012-10-17"
}
EOF

  tags = {
    PolicyDescription = "Single bucket access policy."
  }
}
