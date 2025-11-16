output "eks_iam_role_arn" {
  value = aws_iam_role.eks_role.arn
}

output "eks_node_group_iam_role_arn" {
  value = aws_iam_role.node_group_role.arn
}

output "eks_node_group_role_iam_arn" {
  value = aws_iam_role.node_group_role.arn
}

output "eks_cluster_autoscaler_iam_arn" {
  value = aws_iam_role.cluster_autoscaler_role.arn
}

output "eks_alb_iam_arn" {
  value = aws_iam_role.aws_lbc_role.arn
}
