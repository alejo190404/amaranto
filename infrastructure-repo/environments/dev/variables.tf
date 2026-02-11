# No default: Terraform will prompt for the namespace when you run plan/apply
# (or set via -var="database_k8s_namespace=amaranto-dev" / TF_VAR_database_k8s_namespace)
variable "database_k8s_namespace" {
  description = "Kubernetes namespace where MySQL will be deployed (e.g. amaranto-dev)"
  type        = string
}

variable "mysql_root_password" {
  description = "Root password for local MySQL (required). Pass via -var, tfvars, or TF_VAR_mysql_root_password."
  type        = string
  sensitive   = true
}
