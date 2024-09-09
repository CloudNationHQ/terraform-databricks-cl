# Default

This example highlights the most simple default usage.

## Types

```hcl
cluster = object({
  name                         = string
  runtime_version              = optional(string)
  num_workers                  = optional(number, 1)

  node_type = optional(object({
      min_memory_gb           = optional(number)
      gb_per_core             = optional(number)
      min_cores               = optional(number)
      category                = optional(string)
  }))
})
```

## Notes

This Databricks cluster module has only been tested with a Databricks workspace on Azure cloud, other cloud providers have not been tested yet.