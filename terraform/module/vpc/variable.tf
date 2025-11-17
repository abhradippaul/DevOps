variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets"
  type        = list(string)
}

variable "eks_cluster_name" {
  type = string
}

variable "azs" {
  type = list(string)
}
