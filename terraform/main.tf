locals {
  region      = "ap-south-1"
  zone1       = "ap-south-1a"
  zone2       = "ap-south-1b"
  eks_name    = "devops-project"
  eks_version = "1.33"
}

# S3 bucket creation for static files
module "bucket" {
  source      = "./module/s3"
  bucket_name = var.bucket_name
}

# ECR resource for storing frontend image
resource "aws_ecr_repository" "frontend_ecr" {
  name                 = var.ecr_name[0]
  image_tag_mutability = "MUTABLE"
  lifecycle {
    create_before_destroy = false
  }
}

# ECR resource for storing backend image
resource "aws_ecr_repository" "backend_ecr" {
  name                 = var.ecr_name[1]
  image_tag_mutability = "MUTABLE"
  lifecycle {
    create_before_destroy = false
  }
}

# Create two types of users and grant them permission to pull and push images from ECR.
module "ecr_iam" {
  source                  = "./module/iam"
  depends_on              = [aws_ecr_repository.backend_ecr, aws_ecr_repository.frontend_ecr]
  ecr_iam_pull_group_name = "ecr-pull-group"
  ecr_iam_push_group_name = "ecr-push-group"
  ecr_pull_user_name      = "ecr-pull-user"
  ecr_push_user_name      = "ecr-push-user"
  ecr_arns                = [aws_ecr_repository.backend_ecr.arn, aws_ecr_repository.frontend_ecr.arn]
  iam_pull_policy_name    = "ecr-pull-iam-policy"
  iam_push_policy_name    = "ecr-push-iam-policy"
}

# Create vpc for eks
# module "eks_vpc" {
#   source               = "./module/vpc"
#   az_zones             = var.az_zones
#   private_subnet_cidrs = var.private_subnet_cidrs
#   public_subnet_cidrs  = var.public_subnet_cidrs
#   vpc_cidr             = var.vpc_cidr
#   vpc_name             = "eks_vpc"
# }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 21.0"

#   name                                     = "example"
#   kubernetes_version                       = "1.33"
#   endpoint_public_access                   = true
#   enable_cluster_creator_admin_permissions = true
#   fargate_profiles = {

#   }
#   # cluster_name    = "eks-fargate-cluster"
#   # subnets         = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
#   # vpc_id          = "vpc-xxxxxxxxxxxxxxxxx"
#   # cluster_version = "1.21"
#   # fargate_profile = {
#   #   eks_cluster_name = "eks-fargate-cluster"
#   #   subnets          = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
#   # }
# }
