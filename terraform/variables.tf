variable "project_name" {
    description = "Project name"
    type = string
    default = "nexabank"
}

variable "environment" {
    description = "Environment"
    type = string
    default = "prod"
}

variable "aws_region" {
    description = "AWS region"
    type = string
    default = "us-east-1"
}

variable "account_id" {
    description = "AWS account ID"
    type = string
    default = "560705566578"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "nexabank"
}