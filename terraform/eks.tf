resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.k8-access.arn
  version  = var.eks_version
  vpc_config {
    subnet_ids              = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.vpc_sg.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.k8-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.k8-AmazonEKSVPCResourceController,
  ]
}


resource "aws_eks_addon" "add_ons" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  for_each      = { for idx, addon in var.addons : idx => addon }
  addon_name    = each.value.name
  addon_version = each.value.add_version

  depends_on = [aws_eks_node_group.eks_node_group]
}

output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}