output "cluster" {
  value = databricks_cluster.cluster
}

output "cluster_permissions" {
  value = databricks_permissions.cluster_permissions
}
