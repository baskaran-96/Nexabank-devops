variable "project_name" {
    description = "Project nname"
    type = string
}

variable "environment" {
    description = "Environmrnt"
    type = string
}

variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "private_subnet_ids" {
    description = "Private subnet IDs for EKS nodes"
    type = list(string)
}

variable "eks_cluster_sg_id" {
    description = "EKS cluster security group ID"
    type = string
}

variable "eks_nodes_sg_id" {
    description = "EKS nodes security group ID"
    type = string   
}

variable "cluster_version" {
    description = "Kubernetes version"
    type = string
    default = "1.32"
}

variable "node_instance_type" {
    description = "Ec2 instance type for worker EKS nodes"
    type = string
    default = "t3.medium"
}

variable "node_min_size" {
    description = "Minimum number of worker nodes"
    type = number
    default = 2
}

variable "node_max_size" {
    description = "Maximum number of worker nodes"
    type = number
    default = 4
}

variable "node_desired_size" {
    description = "Desired number of worker nodes"
    type = number
    default = 3
}