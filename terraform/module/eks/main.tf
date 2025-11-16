resource "aws_eks_cluster" "eks" {
  name     = var.eks_cluster_name
  version  = var.eks_version
  role_arn = var.eks_cluster_iam_role

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids              = var.private_subnets
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

# Create Node Group with AutoScaling
resource "aws_eks_node_group" "general" {
  cluster_name    = var.eks_cluster_name
  version         = var.eks_version
  node_group_name = "general"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t3.large"]

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    "role" = "general"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

}

# For EKS CloudWatch logging and metrics
resource "aws_eks_addon" "amazon_cloudwatch_observability" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "amazon-cloudwatch-observability"
}

# For EKS Node Autoscaling
resource "aws_eks_addon" "pod_identity" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "eks-pod-identity-agent"
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  cluster_name    = var.eks_cluster_name
  namespace       = "kube-system"
  service_account = "cluster-autoscaler"
  role_arn        = var.cluster_autoscaler_iam_arn
}

# Create CloudWatch log group
resource "aws_cloudwatch_log_group" "eks_control_plane" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = 7
}

resource "aws_eks_pod_identity_association" "eks_lbc" {
  cluster_name    = var.eks_cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = var.alb_iam_arn
}
