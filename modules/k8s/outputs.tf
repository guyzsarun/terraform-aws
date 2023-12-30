output "kubeconfig_file" {
  value = local_file.kubeconfig.filename
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_cert" {
  value = module.eks.cluster_certificate_authority_data
}