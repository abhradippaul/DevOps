module "bucket" {
  source      = "./module/s3"
  bucket_name = var.bucket_name
}
