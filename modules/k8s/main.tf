module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.20.0"


  cluster_name    = var.eks-config.name
  cluster_version = var.eks-config.version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_id

  cluster_endpoint_public_access = true
  eks_managed_node_groups = {
    node-group-1 = {
      capacity_type  = "SPOT"
      instance_types = ["t3.small"]

      min_size     = var.eks-config.min_node
      max_size     = var.eks-config.max_node
      desired_size = var.eks-config.min_node
    }
    node-group-2 = {
      capacity_type  = "SPOT"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }
}

locals {
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "terraform"
    clusters = [{
      name = module.eks.cluster_name
      cluster = {
        certificate-authority-data = module.eks.cluster_certificate_authority_data
        server                     = module.eks.cluster_endpoint
      }
    }]
    contexts = [{
      name = "terraform"
      context = {
        cluster = module.eks.cluster_name
        user    = "terraform"
      }
    }]
    users = [{
      name = "terraform"
      user = {
        exec = {
          apiVersion         = "client.authentication.k8s.io/v1beta1"
          command            = "aws"
          interactiveMode    = "IfAvailable"
          provideClusterInfo = false
          args = [
            "--region",
            split(":", module.eks.cluster_arn)[3],
            "eks",
            "get-token",
            "--cluster-name",
            "${module.eks.cluster_name}",
            "--output",
            "json"
          ]
        }
      }
    }]
  })
}

resource "local_file" "kubeconfig" {
  content    = local.kubeconfig
  filename   = "kubeconfig_${module.eks.cluster_name}"
  depends_on = [module.eks]
}