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
  source  = "cloudnationhq/cl/databricks"
  version = "~> 1.0"

  cluster = {
    name        = module.naming.databricks_cluster.name
    num_workers = 2

    runtime_version = "14.1.x-scala2.12"

    node_type = {
      id = "Standard_D4ds_v5"
    }
  }

  depends_on = [module.dbw]
}
