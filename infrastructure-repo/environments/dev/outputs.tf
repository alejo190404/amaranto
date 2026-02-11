output "database_host" {
  description = "MySQL host (K8s service DNS)"
  value       = module.database.host
}

output "database_port" {
  description = "MySQL port"
  value       = module.database.port
}

output "database_namespace" {
  description = "Namespace where MySQL is running"
  value       = module.database.k8s_namespace
}
