data "databricks_spark_version" "spark" {
  latest            = try(var.cluster.spark_version.latest, null)
  spark_version     = try(var.cluster.spark_version.spark_version, null)
  gpu               = try(var.cluster.spark_version.gpu, null)
  ml                = try(var.cluster.spark_version.ml, null)
  long_term_support = try(var.cluster.spark_version.long_term_support, null)
  genomics          = try(var.cluster.spark_version.genomics, null)
  beta              = try(var.cluster.spark_version.beta, null)
  scala             = try(var.cluster.spark_version.scala, null)
}

data "databricks_node_type" "node" {
  support_port_forwarding = try(var.cluster.node_type.support_port_forwarding, null)
  min_memory_gb           = try(var.cluster.node_type.min_memory_gb, null)
  gb_per_core             = try(var.cluster.node_type.gb_per_core, null)
  min_cores               = try(var.cluster.node_type.min_cores, null)
  min_gpus                = try(var.cluster.node_type.min_gpus, null)
  local_disk              = try(var.cluster.node_type.local_disk, null)
  local_disk_min_size     = try(var.cluster.node_type.local_disk_min_size, null)
  category                = try(var.cluster.node_type.category, null)
  photon_worker_capable   = try(var.cluster.node_type.photon_worker_capable, null)
  photon_driver_capable   = try(var.cluster.node_type.photon_driver_capable, null)
  graviton                = try(var.cluster.node_type.graviton, null)
  fleet                   = try(var.cluster.node_type.fleet, null)
  is_io_cache_enabled     = try(var.cluster.node_type.is_io_cache_enabled, null)
}


data "databricks_node_type" "driver_node" {
  for_each = try(var.cluster.driver_node_type, {}) != {} ? { "default" = var.cluster.driver_node_type } : {}

  support_port_forwarding = try(var.cluster.driver_node_type.support_port_forwarding, null)
  min_memory_gb           = try(var.cluster.driver_node_type.min_memory_gb, null)
  gb_per_core             = try(var.cluster.driver_node_type.gb_per_core, null)
  min_cores               = try(var.cluster.driver_node_type.min_cores, null)
  min_gpus                = try(var.cluster.driver_node_type.min_gpus, null)
  local_disk              = try(var.cluster.driver_node_type.local_disk, null)
  local_disk_min_size     = try(var.cluster.driver_node_type.local_disk_min_size, null)
  category                = try(var.cluster.driver_node_type.category, null)
  photon_worker_capable   = try(var.cluster.driver_node_type.photon_worker_capable, null)
  photon_driver_capable   = try(var.cluster.driver_node_type.photon_driver_capable, null)
  graviton                = try(var.cluster.driver_node_type.graviton, null)
  fleet                   = try(var.cluster.driver_node_type.fleet, null)
  is_io_cache_enabled     = try(var.cluster.driver_node_type.is_io_cache_enabled, null)
}

resource "databricks_cluster" "cluster" {
  cluster_name = try(var.cluster.name, null)
  ## Even though called spark_version, it is actually the runtime version, runtime version can be lookuped by spark version data block parameters
  spark_version       = coalesce(try(var.cluster.runtime_version, null), data.databricks_spark_version.spark.id)
  node_type_id        = data.databricks_node_type.node.id
  driver_node_type_id = try(data.databricks_node_type.driver_node["default"].id, data.databricks_node_type.node.id)
  runtime_engine      = try(var.cluster.runtime_engine, null)

  instance_pool_id        = try(var.cluster.instance_pool_id, null)
  driver_instance_pool_id = try(var.cluster.driver_instance_pool_id, null)
  policy_id               = try(var.cluster.policy_id, null)

  num_workers                  = try(var.cluster.num_workers, 1)
  autotermination_minutes      = try(var.cluster.autotermination_minutes, 10) ## set to minimal for cost savings
  is_pinned                    = try(var.cluster.is_pinned, false)
  apply_policy_default_values  = try(var.cluster.apply_policy_default_values, false)
  enable_elastic_disk          = try(var.cluster.enable_elastic_disk, false)
  enable_local_disk_encryption = try(var.cluster.enable_local_disk_encryption, null)

  dynamic "autoscale" {
    for_each = try(var.cluster.autoscale, null) != null ? { "default" = var.cluster.autoscale } : {}
    content {
      min_workers = try(autoscale.value.min_workers, 1)
      max_workers = try(autoscale.value.max_workers, 2)
    }
  }

  data_security_mode = try(var.cluster.data_security_mode, null)
  single_user_name   = try(var.cluster.single_user_name, null)
  idempotency_token  = try(var.cluster.idempotency_token, null)
  ssh_public_keys    = try(var.cluster.ssh_public_keys, [])
  spark_env_vars     = try(var.cluster.spark_env_vars, {})
  spark_conf         = try(var.cluster.spark_conf, {})
  custom_tags        = try(var.cluster.custom_tags, {})
}

resource "databricks_permissions" "cluster_permissions" {
  for_each = try(var.cluster.permissions, {}) != {} ? { "default" = var.cluster.permissions } : {}

  cluster_id = databricks_cluster.cluster.id

  dynamic "access_control" {
    for_each = {
      for key, ac in each.value : key => ac
    }
    content {
      group_name             = try(access_control.value.group_name, null)
      user_name              = try(access_control.value.user_name, null)
      service_principal_name = try(access_control.value.service_principal_name, null)
      permission_level       = access_control.value.permission_level
    }
  }
}

