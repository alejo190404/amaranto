output "host" {
  description = "MySQL host to connect to (K8s service name or RDS endpoint)."
  value       = "${kubernetes_service_v1.mysql[0].metadata[0].name}.${var.k8s_namespace}.svc.cluster.local"
}

output "port" {
  description = "MySQL port (always 3306)."
  value       = 3306
}

output "engine_version" {
  description = "MySQL engine version in use."
  value       = var.mysql_engine_version
}

output "k8s_namespace" {
  description = "Kubernetes namespace where MySQL is deployed (local only)."
  value       = local.is_local ? var.k8s_namespace : null
}

# # For prod: RDS endpoint and port (for apps that need full endpoint)
# output "rds_endpoint" {
#   description = "RDS instance endpoint (prod only)."
#   value       = local.is_prod ? aws_db_instance.mysql[0].endpoint : null
# }

# output "rds_port" {
#   description = "RDS instance port (prod only)."
#   value       = local.is_prod ? aws_db_instance.mysql[0].port : null
# }
