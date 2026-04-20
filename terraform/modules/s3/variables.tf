variable "project_name" {
    description = "Project name used for naming resource"
    type = string
}

variable "environment" {
    description = "Environment (dev, staging, prod) used for naming resource"
    type = string
}

variable"account_id" {
    description = "AWS Account ID used for naming resource"
    type = string   
}
