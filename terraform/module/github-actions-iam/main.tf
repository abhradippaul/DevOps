resource "aws_iam_group" "ecr_push_group" {
  name = var.ecr_iam_push_group_name
}

data "aws_iam_policy_document" "ecr_push_policy_document" {

  statement {
    sid    = "ECRAuthToken"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ECRPushAction"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    resources = var.ecr_arns
  }
}

resource "aws_iam_policy" "ecr_push_policy" {
  name        = var.iam_push_policy_name
  description = "Only able to push the image"
  policy      = data.aws_iam_policy_document.ecr_push_policy_document.json
}

resource "aws_iam_group_policy_attachment" "ecr_push_group_attachment" {
  group      = aws_iam_group.ecr_push_group.id
  policy_arn = aws_iam_policy.ecr_push_policy.arn
}

resource "aws_iam_user" "ecr_push_user" {
  name = var.ecr_push_user_name
}

resource "aws_iam_user_group_membership" "ecr_push_user_attachment" {
  user   = aws_iam_user.ecr_push_user.id
  groups = [aws_iam_group.ecr_push_group.name]
}

resource "aws_iam_access_key" "push_user_access_key" {
  user = aws_iam_user.ecr_push_user.name
}
