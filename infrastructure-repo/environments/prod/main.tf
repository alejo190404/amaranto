terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# MySQL: runs as AWS RDS with the same engine version as local
module "database" {
  source = "../../modules/database"

  deploy_mode          = "prod"
  mysql_engine_version = "8.0.35"

  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  instance_class        = var.instance_class
  allocated_storage_gb  = var.allocated_storage_gb
  subnet_ids            = var.subnet_ids
  vpc_security_group_ids = var.vpc_security_group_ids
  rds_identifier        = var.rds_identifier
  skip_final_snapshot   = var.skip_final_snapshot
}
