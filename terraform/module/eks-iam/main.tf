data "aws_iam_policy_document" "eks_trust_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]

  }
}

resource "aws_iam_role" "eks_role" {
  name               = "${var.eks_cluster_name}-eks-cluster"
  assume_role_policy = data.aws_iam_policy_document.eks_trust_policy_document.json
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy_document" "eks_node_trust_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]

  }
}

# Create role for Node Group and Assign policy
resource "aws_iam_role" "node_group_role" {
  name               = "${var.node_group_policy_name}-eks-node"
  assume_role_policy = data.aws_iam_policy_document.eks_node_trust_policy_document.json
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ecr_readonly_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_cloudwatch_agent_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_ssm_managed_instance_core_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create Cluster AutoScaler Permission

data "aws_iam_policy_document" "eks_cluster_autoscaler_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole", "sts:TagSession"
    ]
  }
  statement {
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"

    ]
    resources = ["*"]

  }
}

resource "aws_iam_policy" "cluster_autoscaler_policy" {
  policy = data.aws_iam_policy_document.eks_cluster_autoscaler_policy_document.json
  name   = "${var.eks_cluster_name}-cluster_autoscaler_policy"
}

resource "aws_iam_role" "cluster_autoscaler_role" {
  name               = "${var.eks_cluster_name}-cluster_autoscaler"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_autoscaler_policy_document.json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
  role       = aws_iam_role.cluster_autoscaler_role.name
}

data "aws_iam_policy_document" "aws_lbc" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole", "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "aws_lbc_role" {
  name               = "${var.eks_cluster_name}-aws_lbc"
  assume_role_policy = data.aws_iam_policy_document.aws_lbc.json
}

resource "aws_iam_policy" "aws_lbc_policy" {
  policy = file("./AWSLoadBalancerController.json")
  name   = "AWSLoadBalancerController"
}

resource "aws_iam_role_policy_attachment" "aws_lbc_policy_attachment" {
  policy_arn = aws_iam_policy.aws_lbc_policy.arn
  role       = aws_iam_role.cluster_autoscaler_role.name
}

