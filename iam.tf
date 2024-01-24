resource "aws_iam_role" "eks_cluster_role" {
  name               = var.eks_cluster_role_name
  tags               = merge(var.tags, {
    Name             = "${var.cluster_name}-eks"
  })
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "EKSClusterAssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name   = var.cluster_name
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Action   = [
            "logs:CreateLogGroup"
            ]
          Effect   = "Deny"
          Resource = "arn:aws:logs:us-east-2:621672204142:log-group:/aws/eks/${var.cluster_name}/cluster"
        }
      ]
    })
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role" "eks_node_group_roles" {
  for_each    = var.eks_node_groups
  name        = each.value["role_name"]
  description = "Allows EKS instances to call AWS services on your behalf."
  tags        = merge(var.tags, {
    EKS-Name  = var.cluster_name
  })
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "EKSNodeAssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_attachment" {
  depends_on = [ aws_iam_role.eks_node_group_roles ]
  for_each   = var.eks_node_groups
  role       = each.value["role_name"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_read_only_policy_attachment" {
  depends_on = [ aws_iam_role.eks_node_group_roles ]
  for_each   = var.eks_node_groups
  role       = each.value["role_name"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core_policy_attachment" {
  depends_on = [ aws_iam_role.eks_node_group_roles ]
  for_each   = var.eks_node_groups
  role       = each.value["role_name"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  depends_on = [ aws_iam_role.eks_node_group_roles ]
  for_each   = var.eks_node_groups
  role       = each.value["role_name"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ebs_csi_driver_policy_attachment" {
  depends_on = [ aws_iam_role.eks_node_group_roles ]
  for_each   = var.eks_node_groups
  role       = each.value["role_name"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
