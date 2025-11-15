module "bucket" {
  source      = "./module/s3"
  bucket_name = var.bucket_name
}

resource "aws_ecr_repository" "frontend_ecr" {
  name                 = var.ecr_name[0]
  image_tag_mutability = "MUTABLE"
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_ecr_repository" "backend_ecr" {
  name                 = var.ecr_name[1]
  image_tag_mutability = "MUTABLE"
  lifecycle {
    create_before_destroy = false
  }
}


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
