terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.24.0"
    }
  }
}

provider "aws" {
  region     = var.aws_credentials.region
  access_key = var.aws_credentials.access_key
  secret_key = var.aws_credentials.secret_key

  default_tags {
    tags = {
      Managed_by = "terraform"
    }
  }
}