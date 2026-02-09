terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "Dev"
      ManagedBy   = "Terraform"
      Department  = "DevOps"
      UsedFor     = "Staic Hosting"
    }
  }
}
