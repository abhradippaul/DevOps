terraform {
  backend "s3" {
    bucket         = "abhradippaul-terraform-state"
    key            = "cloudfront_terraform/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
