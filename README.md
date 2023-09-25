## S3 Load test
This respository comprises of a solution to perform load test on s3-compatible infrastructure.

> **NOTE:** *The github workflows are not working as the AWS credentials are missing.*


#### Directory structure

```bash
.
├── .github
│   └── workflows
│       ├── ecr.yaml
│       └── terraform.yaml
├── .gitignore
├── Dockerfile
├── README.md
├── helm
│   ├── .helmignore
│   ├── Chart.yaml
│   ├── templates
│   │   ├── NOTES.txt
│   │   ├── _helpers.tpl
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── tests
│   └── values.yaml
└── terraform
    ├── README.md
    ├── eks.tf
    ├── helm.tf
    ├── iam.tf
    ├── outputs.tf
    ├── s3.tf
    ├── terraform.tfvars
    ├── variables.tf
    ├── versions.tf
    └── vpc.tf
```

#### Pre-requisites
* A `deployment` AWS IAM user with Administrator access.
* AWS KEYS for `deployment` user.
* An S3 bucket for Terraform backend.
* ECR reposirtory details.

#### Getting started
* Step 1 : Build and push `s3-load-test` image to ECR (githubActions)
* Step 2 : Deploy resources in `./terraform` directory using github-actions.
* Step 3 : Once tested destory terraform resources using `tf destroy -auto-approve`





