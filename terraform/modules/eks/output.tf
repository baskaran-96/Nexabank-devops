output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.nexabank.name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.nexabank.endpoint
}

output "cluster_certificate_authority" {
  description = "EKS cluster certificate authority"
  value       = aws_eks_cluster.nexabank.certificate_authority[0].data
}

output "node_group_name" {
  description = "EKS node group name"
  value       = aws_eks_node_group.nexabank.node_group_name
}