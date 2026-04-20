terraform {
    backend "s3" {
      bucket         = "nexabank-tfstate-prod"
      key            = "nexabank/terraform.tfstate"
      region         = "us-east-1"
      encrypt        = true
      dynamodb_table = "nexabank-terraform-state-lock"
   }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"

        }
    }

    required_version = ">= 1.5.0"
}

