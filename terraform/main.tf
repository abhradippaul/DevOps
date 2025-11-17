locals {
  region      = "ap-south-1"
  eks_name    = "devops-project"
  eks_version = "1.33"
}

# S3 bucket creation for static files
module "bucket" {
  source      = "./module/s3"
  bucket_name = var.bucket_name
}

# Create EKS iam permission needed
module "eks_iam" {
  source                 = "./module/eks-iam"
  eks_cluster_name       = local.eks_name
  eks_policy_name        = "eks_cluster_policy"
  node_group_policy_name = "node_group_policy"
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

# Creates push iam for github action image push
module "github_actions_iam" {
  source                  = "./module/github-actions-iam"
  ecr_arns                = [aws_ecr_repository.backend_ecr.arn, aws_ecr_repository.frontend_ecr.arn]
  ecr_iam_push_group_name = "ecr-push-group"
  ecr_push_user_name      = "ecr-push-user"
  iam_push_policy_name    = "ecr-push-iam-policy"
}

# Create VPC for EKS
# module "eks_vpc" {
#   source               = "./module/vpc"
#   az_zones             = var.az_zones
#   private_subnet_cidrs = var.private_subnet_cidrs
#   public_subnet_cidrs  = var.public_subnet_cidrs
#   vpc_cidr             = var.vpc_cidr
#   vpc_name             = "eks_vpc"
# }

# Create EKS Cluster
# module "eks" {
#   source                     = "./module/eks"
#   depends_on                 = [module.eks_vpc.private_subnets, module.eks_iam.eks_iam_role_arn]
#   aws_region                 = local.region
#   eks_cluster_iam_role       = module.eks_iam.eks_iam_role_arn
#   eks_cluster_name           = local.eks_name
#   eks_version                = local.eks_version
#   private_subnets            = module.eks_vpc.private_subnets
#   cluster_autoscaler_iam_arn = module.eks_iam.eks_cluster_autoscaler_iam_arn
#   node_role_arn              = module.eks_iam.eks_node_group_iam_role_arn
#   alb_iam_arn                = module.eks_iam.eks_alb_iam_arn
# }
