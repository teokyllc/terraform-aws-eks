resource "kubernetes_config_map_v1_data" "aws-auth" {
  depends_on = [ aws_eks_node_group.eks_node_groups ]
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    "mapUsers" = var.admin_user_map
  }

  force = true
}