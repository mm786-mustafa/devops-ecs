terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Uncomment after first deployment to use S3 backend
  # backend "s3" {
  #   bucket         = "devops-portfolio-tfstate"
  #   key            = "ecs/terraform.tfstate"
  #   region         = "us-east-2"
  #   encrypt        = true
  #   dynamodb_table = "terraform-locks"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "devops-portfolio"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}