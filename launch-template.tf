resource "aws_launch_template" "launch_template" {
  for_each      = var.eks_node_groups
  name          = each.value["launch_template_name"]
  instance_type = each.value["launch_template_instance_type"]
  key_name      = each.value["launch_template_key_name"]

  block_device_mappings {
    device_name = each.value["launch_template_block_device_name"]

    ebs {
      volume_size           = each.value["volume_size"]
      delete_on_termination = true
    }
  }

  network_interfaces {
    security_groups = [aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = var.tags
  }
}
