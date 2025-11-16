variable "ecr_iam_push_group_name" {
  type = string
}

variable "iam_push_policy_name" {
  type = string
}

variable "ecr_arns" {
  type = list(string)
}

variable "ecr_push_user_name" {
  type = string
}
