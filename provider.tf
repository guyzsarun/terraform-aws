terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.24.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
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

provider "helm" {
  kubernetes {

     host                   = module.k8s.cluster_endpoint
    cluster_ca_certificate = base64decode(module.k8s.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks-config.name]
      command     = "aws"
    }
  }
}