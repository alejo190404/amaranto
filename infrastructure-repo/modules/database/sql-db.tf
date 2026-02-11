# -----------------------------------------------------------------------------
# Local: MySQL as a container in Kubernetes (same engine/version as RDS)
# -----------------------------------------------------------------------------

locals {
  # MySQL image tag matches engine version for consistency
  mysql_image = "mysql:${var.mysql_engine_version}"
  is_local    = var.deploy_mode == "local"
  # is_prod     = var.deploy_mode == "prod"
}

resource "kubernetes_persistent_volume_claim_v1" "mysql_data" {
  count = local.is_local ? 1 : 0

  metadata {
    name      = "mysql-data"
    namespace = var.k8s_namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.local_storage_size
      }
    }
  }
}

resource "kubernetes_deployment_v1" "mysql" {
  count = local.is_local ? 1 : 0

  lifecycle {
    precondition {
      condition     = !local.is_local || (var.mysql_root_password != null && var.mysql_root_password != "")
      error_message = "mysql_root_password is required when deploy_mode is 'local'. Pass it via variable, -var, or TF_VAR_mysql_root_password."
    }
  }

  metadata {
    name      = "mysql"
    namespace = var.k8s_namespace
    labels = {
      app = "mysql"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = local.mysql_image

          port {
            container_port = 3306
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.mysql_root_password
          }

          volume_mount {
            name       = "mysql-data"
            mount_path = "/var/lib/mysql"
          }

          resources {
            requests = {
              memory = "256Mi"
              cpu    = "100m"
            }
            limits = {
              memory = "512Mi"
              cpu    = "500m"
            }
          }
        }

        volume {
          name = "mysql-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.mysql_data[0].metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "mysql" {
  count = local.is_local ? 1 : 0

  metadata {
    name      = "mysql"
    namespace = var.k8s_namespace
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.mysql[0].metadata[0].labels.app
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}

# # -----------------------------------------------------------------------------
# # Prod: AWS RDS MySQL (same engine version)
# # -----------------------------------------------------------------------------

# resource "aws_db_subnet_group" "main" {
#   count = local.is_prod && length(var.subnet_ids) > 0 ? 1 : 0

#   name       = "${var.rds_identifier}-subnet-group"
#   subnet_ids = var.subnet_ids
# }

# resource "aws_db_instance" "mysql" {
#   count = local.is_prod ? 1 : 0

#   identifier     = var.rds_identifier
#   engine         = "mysql"
#   engine_version = var.mysql_engine_version

#   db_name  = var.db_name
#   username = var.db_username != null ? var.db_username : "admin"
#   password = var.db_password

#   instance_class    = var.instance_class
#   allocated_storage = var.allocated_storage_gb

#   db_subnet_group_name   = length(var.subnet_ids) > 0 ? aws_db_subnet_group.main[0].name : null
#   vpc_security_group_ids = var.vpc_security_group_ids
#   publicly_accessible    = length(var.subnet_ids) == 0 ? true : false

#   skip_final_snapshot       = var.skip_final_snapshot
#   deletion_protection       = false
#   backup_retention_period   = 7
#   multi_az                  = false
#   storage_encrypted         = true
# }
