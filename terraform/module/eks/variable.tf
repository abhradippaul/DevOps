variable "aws_region" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "eks_cluster_iam_role" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "node_role_arn" {
  type = string
}

variable "cluster_autoscaler_iam_arn" {
  type = string
}

variable "alb_iam_arn" {
  type = string
}
