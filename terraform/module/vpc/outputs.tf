output "private_subnets" {
  value = aws_subnet.eks_subnet_private[*].id
}

output "public_subnets" {
  value = aws_subnet.eks_subnet_public[*].id
}
