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
  
  # Explicitly targets the minikube context to avoid accidentally applying to prod
  config_context = "minikube"
}

module "cluster" {
  source = "../../modules/cluster"
  
  env             = "dev"
  namespace       = "amaranto"
}
