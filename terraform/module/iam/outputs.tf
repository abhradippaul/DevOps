output "pull_user_access_key_id" {
  value = aws_iam_access_key.pull_user_access_key.id
}

output "pull_user_secret_access_key" {
  value = aws_iam_access_key.pull_user_access_key.ses_smtp_password_v4
}

output "push_user_access_key_id" {
  value = aws_iam_access_key.push_user_access_key.id
}

output "push_user_secret_access_key" {
  value = aws_iam_access_key.push_user_access_key.ses_smtp_password_v4
}
