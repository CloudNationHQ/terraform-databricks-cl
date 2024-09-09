# Complete

This example highlights the complete usage.

## Types

```hcl
cluster = object({
  name                         = string
  runtime_version              = optional(string)
  runtime_engine               = optional(string)
  instance_pool_id             = optional(string)
  policy_id                    = optional(string)
  is_pinned                    = optional(bool, false)
  num_workers                  = optional(number, 1)
  autotermination_minutes      = optional(number, 10)
  apply_policy_default_values  = optional(bool)
  enable_elastic_disk          = optional(bool)
  enable_local_disk_encryption = optional(bool)

  autoscale = optional(object({
    min_workers = optional(number, 1)
    max_workers = optional(number, 2)
  }))

  spark_version   = optional(object({
    spark_version     = optional(string)
    scala             = optional(string)
    latest            = optional(bool)
    gpu               = optional(bool)
    ml                = optional(bool)
    long_term_support = optional(bool)
    genomics          = optional(bool)
    beta              = optional(bool)
  }))
  
  node_type = optional(object({
      min_memory_gb           = optional(number)
      gb_per_core             = optional(number)
      min_cores               = optional(number)
      min_gpus                = optional(number)
      local_disk              = optional(bool)
      local_disk_min_size     = optional(number)
      category                = optional(string)
      photon_worker_capable   = optional(bool)
      photon_driver_capable   = optional(bool)
      graviton                = optional(bool)
      fleet                   = optional(bool)
      is_io_cache_enabled     = optional(bool)
      support_port_forwarding = optional(bool)
  }))

  driver_node_type = optional(object({
      min_memory_gb           = optional(number)
      gb_per_core             = optional(number)
      min_cores               = optional(number)
      min_gpus                = optional(number)
      local_disk              = optional(bool)
      local_disk_min_size     = optional(number)
      category                = optional(string)
      photon_worker_capable   = optional(bool)
      photon_driver_capable   = optional(bool)
      graviton                = optional(bool)
      fleet                   = optional(bool)
      is_io_cache_enabled     = optional(bool)
      support_port_forwarding = optional(bool)
     }
  ))
})
```

## Notes

This Databricks cluster module has only been tested with a Databricks workspace on Azure cloud, other cloud providers have not been tested yet.