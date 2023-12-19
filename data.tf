data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_subnets" "eks_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Tier = var.eks_subnet_tier
  }
}

data "tls_certificate" "eks_issuer_cert" {
 url = aws_eks_cluster.eks.identity.0.oidc.0.issuer
}
