variable "bucket_name" {
  type    = string
  default = "abhradippaul-devops-project"
}

variable "ecr_name" {
  type    = list(string)
  default = ["abhradippaul/nodejs-frontend-devops", "abhradippaul/nodejs-backend-devops"]
}
