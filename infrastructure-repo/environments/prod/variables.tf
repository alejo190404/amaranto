variable "aws_region" {
  description = "AWS region for RDS"
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  description = "Default database name"
  type        = string
  default     = "amaranto"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage_gb" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "subnet_ids" {
  description = "Subnet IDs for RDS (private subnets recommended)"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Security group IDs to attach to RDS"
  type        = list(string)
}

variable "rds_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "amaranto-mysql"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy (set to false in prod for safety)"
  type        = bool
  default     = false
}
