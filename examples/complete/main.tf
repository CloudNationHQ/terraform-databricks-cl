module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "dbw" {
  source  = "cloudnationhq/dbw/azure"
  version = "~> 1.0"

  workspace = {
    name           = module.naming.databricks_workspace.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    sku            = "premium"
  }
}

module "cluster" {
  source  = "cloudnationhq/cl/db"
  version = "~> 1.0"

  cluster = {
    name                         = module.naming.databricks_cluster.name
    node_type_id                 = "Standard_F4s"
    runtime_engine               = "PHOTON"
    is_pinned                    = true
    enable_elastic_disk          = true
    enable_local_disk_encryption = true
    autotermination_minutes      = 20
    num_workers                  = 0
    data_security_mode           = "USER_ISOLATION"
    idempotency_token            = "token-${module.naming.databricks_cluster.name}"

    autoscale = {
      min_workers = 1
      max_workers = 5
    }

    spark_version = {
      spark_version = "3.4"
      scala         = "2.12"
    }

    node_type = {
      support_port_forwarding = true
      min_memory_gb           = 32
      gb_per_core             = 4
      min_cores               = 4
      min_gpus                = 0
      local_disk              = true
      local_disk_min_size     = 128
      category                = "General Purpose"
    }

    driver_node_type = {
      support_port_forwarding = true
      min_memory_gb           = 16
      gb_per_core             = 8
      min_cores               = 4
      min_gpus                = 0
      local_disk              = true
      local_disk_min_size     = 64
      category                = "Memory Optimized"
    }

    spark_conf = {
      "spark.databricks.io.cache.enabled" : true,
      "spark.databricks.io.cache.maxDiskUsage" : "50g",
      "spark.databricks.io.cache.maxMetaDataCache" : "1g"
    }

    spark_env_vars = {
      "SPARK_WORKER_MEMORY" = "10g"
      "SPARK_LOCAL_DIRS"    = "/tmp/spark"
    }

    permissions = {
      group1 = {
        group_name       = "users"
        permission_level = "CAN_ATTACH_TO"
      }
    }
  }

  depends_on = [module.dbw]
}
