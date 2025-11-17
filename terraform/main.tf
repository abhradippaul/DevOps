# S3 bucket creation for static files
locals {
  eks_version = "1.33"
}

module "bucket" {
  source      = "./module/s3"
  bucket_name = var.bucket_name
}

# ECR resource for storing frontend image
resource "aws_ecr_repository" "frontend_ecr" {
  name                 = var.ecr_name[0]
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  lifecycle {
    create_before_destroy = false
  }
}

# ECR resource for storing backend image
resource "aws_ecr_repository" "backend_ecr" {
  name                 = var.ecr_name[1]
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  lifecycle {
    create_before_destroy = false
  }
}

# Creates User for push image to ECR
module "github_actions_iam" {
  source                  = "./module/github-actions-iam"
  ecr_arns                = [aws_ecr_repository.backend_ecr.arn, aws_ecr_repository.frontend_ecr.arn]
  ecr_iam_push_group_name = "ecr-push-group"
  ecr_push_user_name      = "ecr-push-user"
  iam_push_policy_name    = "ecr-push-iam-policy"
}

# Create VPC for EKS Cluster
module "eks_vpc" {
  source               = "./module/vpc"
  eks_cluster_name     = var.eks_cluster_name
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  vpc_cidr             = var.vpc_cidr
  azs                  = var.az_zones
}

# Create EKS Cluster
module "eks" {
  source            = "./module/eks"
  eks_cluster_name  = var.eks_cluster_name
  eks_version       = local.eks_version
  subnet_ids        = module.eks_vpc.private_subnet_ids
  vpc_id            = module.eks_vpc.vpc_id
  security_group_id = module.eks_vpc.security_group_id
}
