variable "project_name" {
    description = "Project name"
    type = string
}

variable "environment" {
    description = "Environment"
    type = string
}

variable "public_subnet_id" {
    description = "Public subnet ID for Bastion host"
    type = string
}

variable "bastion_sg_id" {
    description = "Security group ID for Bastion host"
    type = string
}

variable "instance_type" {
    description = "EC2 instance type for Bastion Host"
    type = string
    default = "t3.micro"
}

variable "key_pair_name" {
    description = "Key pair name for EC2 pair"
    type = string
    default = "nexabank-key"
}