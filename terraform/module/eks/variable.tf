variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "security_group_id" {
  type = string
}
