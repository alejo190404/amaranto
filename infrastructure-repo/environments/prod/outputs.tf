output "database_endpoint" {
  description = "RDS MySQL endpoint"
  value       = module.database.rds_endpoint
}

output "database_port" {
  description = "RDS MySQL port"
  value       = module.database.rds_port
}

output "database_host" {
  description = "MySQL host"
  value       = module.database.host
}
