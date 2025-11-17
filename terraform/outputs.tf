output "bucket_dns" {
  value = module.bucket.s3_domain_name
}

output "frontend_ecr_url" {
  value = aws_ecr_repository.frontend_ecr.repository_url
}

output "backend_ecr_url" {
  value = aws_ecr_repository.backend_ecr.repository_url
}

output "push_user_access_key_id" {
  value = module.github_actions_iam.push_user_access_key_id
}

output "push_user_secret_access_key" {
  value     = module.github_actions_iam.push_user_secret_access_key
  sensitive = true
}

# output "cluster_endpoint" {
#   description = "Endpoint for EKS control plane"
#   value       = module.eks.cluster_endpoint
# }

# output "cluster_security_group_id" {
#   description = "Security group ids attached to the cluster control plane"
#   value       = module.eks.cluster_security_group_id
# }

# output "region" {
#   description = "AWS region"
#   value       = local.region
# }

# output "cluster_name" {
#   description = "Kubernetes Cluster Name"
#   value       = module.eks.cluster_name
# }
