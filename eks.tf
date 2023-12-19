resource "aws_cloudwatch_log_group" "eks_control_plane_log_group" {
  count             = var.enable_eks_control_plane_logging ? 1 : 0
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.eks_control_plane_logging_retention_in_days
  tags              = var.tags
}

resource "aws_eks_cluster" "eks" {
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  version                   = var.eks_version
  enabled_cluster_log_types = var.cluster_log_types
  tags                      = merge(var.tags, {
    Name = "${var.cluster_name}-eks"
  })

  vpc_config {
    subnet_ids              = data.aws_subnets.eks_subnets.ids
    endpoint_private_access = var.enable_private_access
    endpoint_public_access  = var.enable_public_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = var.additional_security_groups
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
  }
}

resource "aws_eks_node_group" "eks_node_groups" {
  for_each        = var.eks_node_groups
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.eks_node_group_roles[each.key].arn
  subnet_ids      = data.aws_subnets.eks_subnets.ids
  capacity_type   = "ON_DEMAND"
  labels          = each.value["labels"]
  tags            = merge(var.tags, {
    Name          = "${var.cluster_name}-${each.key}"
  })

  launch_template {
    id      = aws_launch_template.launch_template[each.key].id
    version = each.value["launch_template_version"]
  }

  scaling_config {
    desired_size = each.value["node_pool_desired_size"]
    min_size     = each.value["node_pool_min_size"]
    max_size     = each.value["node_pool_max_size"]
  }
}

resource "aws_eks_addon" "ebs_csi_driver" {
  depends_on                  = [aws_eks_node_group.eks_node_groups]
  cluster_name                = aws_eks_cluster.eks.name
  addon_name                  = "aws-ebs-csi-driver"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "efs_csi_driver" {
  depends_on                  = [aws_eks_node_group.eks_node_groups]
  cluster_name                = aws_eks_cluster.eks.name
  addon_name                  = "aws-efs-csi-driver"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_iam_openid_connect_provider" "iam_openid_connect_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_issuer_cert.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks.identity.0.oidc.0.issuer
}
