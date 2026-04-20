#===================
#nexabank root configuration
#===================    

provider "aws" {
    region = var.aws_region
}

#===================
# S3  module - remote state storage
#===================
module "s3" {
    source = "./modules/s3"

    project_name = var.project_name
    environment = var.environment
    account_id = var.account_id
}

# -----------------------------------------------------------
# VPC Module - Networking
# -----------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# -----------------------------------------------------------
# Security Groups Module
# -----------------------------------------------------------
module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

# -----------------------------------------------------------
# EC2 Module - Bastion Host
# -----------------------------------------------------------
module "ec2" {
    source = "./modules/ec2"

    project_name = var.project_name
    environment = var.environment
    public_subnet_id = module.vpc.public_subnet_ids[0]
    bastion_sg_id = module.security_groups.bastion_sg_id
    instance_type = "t3.micro"
    key_pair_name = "nexabank-key"
}

# -----------------------------------------------------------
# EKS Cluster Module
# -----------------------------------------------------------
module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_cluster_sg_id  = module.security_groups.eks_cluster_sg_id
  eks_nodes_sg_id    = module.security_groups.eks_nodes_sg_id
  cluster_version    = "1.32"
  node_instance_type = "t3.medium"
  node_min_size      = 2
  node_max_size      = 6
  node_desired_size  = 3
}

# -----------------------------------------------------------
# RDS PostgreSQL Module
# -----------------------------------------------------------
module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  instance_class     = "db.t3.micro"
}