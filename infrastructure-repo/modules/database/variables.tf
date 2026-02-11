variable "deploy_mode" {
  description = "Where to deploy MySQL: 'local' = Kubernetes container, 'prod' = AWS RDS"
  type        = string

  validation {
    condition     = contains(["local", "prod"], var.deploy_mode)
    error_message = "deploy_mode must be 'local' or 'prod'."
  }
}

variable "mysql_engine_version" {
  description = "MySQL engine version (e.g. 8.0.35). Same version is used for both K8s image and RDS."
  type        = string
  default     = "8.0.35"
}

# ----- Local (Kubernetes) -----
variable "k8s_namespace" {
  description = "Kubernetes namespace to deploy MySQL into (required when deploy_mode = 'local'). Omit default to be prompted at apply time."
  type        = string
  default     = null
}

variable "mysql_root_password" {
  description = "Root password for MySQL (required when deploy_mode = 'local'). Pass via -var, tfvars, or TF_VAR_mysql_root_password."
  type        = string
  sensitive   = true
  default     = null
}

variable "local_storage_size" {
  description = "Persistent volume size for local MySQL (e.g. '5Gi')."
  type        = string
  default     = "5Gi"
}

# # ----- Prod (AWS RDS) -----
# variable "db_name" {
#   description = "Name of the default database to create (RDS only)."
#   type        = string
#   default     = "amaranto"
# }

# variable "db_username" {
#   description = "Master username for RDS (prod only)."
#   type        = string
#   default     = null
# }

# variable "db_password" {
#   description = "Master password for RDS (prod only)."
#   type        = string
#   sensitive   = true
#   default     = null
# }

# variable "instance_class" {
#   description = "RDS instance class (e.g. db.t3.micro)."
#   type        = string
#   default     = "db.t3.micro"
# }

# variable "allocated_storage_gb" {
#   description = "Allocated storage in GB for RDS."
#   type        = number
#   default     = 20
# }

# variable "subnet_ids" {
#   description = "List of subnet IDs for RDS subnet group (prod only)."
#   type        = list(string)
#   default     = []
# }

# variable "vpc_security_group_ids" {
#   description = "Security group IDs to attach to RDS (prod only)."
#   type        = list(string)
#   default     = []
# }

# variable "rds_identifier" {
#   description = "Identifier for the RDS instance (prod only)."
#   type        = string
#   default     = "amaranto-mysql"
# }

# variable "skip_final_snapshot" {
#   description = "Skip final snapshot when destroying RDS (set false in prod for safety)."
#   type        = bool
#   default     = true
# }
