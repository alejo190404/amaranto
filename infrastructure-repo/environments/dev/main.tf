terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

# 1. Configure the Provider to use your local Minikube credentials
provider "kubernetes" {
  # This points to your standard local kubeconfig file
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

module "cluster" {
  source = "../../modules/cluster"

  env       = "dev"
  namespace = "amaranto"
}

# MySQL: runs as a container in your chosen namespace (you will be prompted for k8s_namespace if not set)
module "database" {
  source = "../../modules/database"

  deploy_mode          = "local"
  mysql_engine_version  = "8.0.35"
  k8s_namespace         = var.database_k8s_namespace
  mysql_root_password   = var.mysql_root_password
  local_storage_size    = "5Gi"
}
