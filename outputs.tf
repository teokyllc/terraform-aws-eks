output "eks_control_plane_log_group_arn" {
  value = var.enable_eks_control_plane_logging ? aws_cloudwatch_log_group.eks_control_plane_log_group[0].arn : null
}

output "eks_control_plane_log_group_name" {
  value = var.enable_eks_control_plane_logging ? aws_cloudwatch_log_group.eks_control_plane_log_group[0].name : null
}

output "eks_id" {
  value = aws_eks_cluster.eks.id
}

output "eks_arn" {
  value = aws_eks_cluster.eks.arn
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_platform_version" {
  value = aws_eks_cluster.eks.platform_version
}

output "eks_certificate_authority" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_oidc_issuer" {
  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

output "eks_oidc_hash" {
  value = split("/", aws_eks_cluster.eks.identity[0].oidc[0].issuer)[4]
}

output "eks_cluster_security_group_id" {
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

output "eks_node_groups" {
  value = aws_eks_node_group.eks_node_groups
}

output "launch_templates" {
  value = aws_launch_template.launch_template
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_cluster_role_name" {
  value = aws_iam_role.eks_cluster_role.name
}

output "eks_node_group_roles" {
  value = aws_iam_role.eks_node_group_roles
}
