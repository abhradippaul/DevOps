variable "bucket_name" {
  type    = string
  default = "abhradippaul-devops-project"
}

variable "ecr_name" {
  type    = list(string)
  default = ["abhradippaul/nodejs-frontend-devops", "abhradippaul/nodejs-backend-devops"]
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "eks_cluster_name" {
  default = "eks-devops-project"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "az_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}
