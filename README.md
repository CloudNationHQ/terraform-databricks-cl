# Databricks cluster

This Terraform module allows for the creation and management of a Databricks cluster with support for setting permissions and looking up driver node types and runtime spark versions. It integrates with Terratest to ensure the robustness and reliability of your infrastructure.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Non-Goals

These modules are not intended to be complete, ready-to-use solutions; they are designed as components for creating your own patterns.

They are not tailored for a single use case but are meant to be versatile and applicable to a range of scenarios.

Security standardization is applied at the pattern level, while the modules include default values based on best practices but do not enforce specific security standards.

End-to-end testing is not conducted on these modules, as they are individual components and do not undergo the extensive testing reserved for complete patterns or solutions.

## Features

- provision Databricks clusters with ease using Terraform
- utilization of Terratest for robust validation
- set permissions for a Databricks cluster
- dynamically retrieve and set the cluster node type for the cluster driver by utilizing the node type data resource with specific query parameters
- dynamically retrieve and set the cluster runtime version using the spark version data resource with specific query parameters

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~> 1.51 |
| <a name="requirement_databricks_workspace"></a> [databricks workspace](#requirement\_databricks_workspace) | ~> n/a |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | ~> 1.51 |

## Resources

| Name | Type |
| :-- | :-- |
| [databricks_cluster](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster) | resource |
| [databricks_permissions](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_spark_version](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/spark_version) | data source |
| [databricks_node_type](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/node_type) | data source |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `cluster` | describes databricks cluster related configuration | object | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `cluster` | contains the databricks cluster details |
| `cluster_permissions` | contains the databricks cluster permissions details |

## Testing

As a prerequirement, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) includes two distinct variations of tests. The first one is designed to deploy different usage scenarios of the module. These tests are executed by specifying the TF_PATH environment variable, which determines the different usages located in the example directory.

To execute this test, input the command ```make test TF_PATH=default```, substituting default with the specific usage you wish to test.

The second variation is known as a extended test. This one performs additional checks and can be executed without specifying any parameters, using the command ```make test_extended```.

Both are designed to be executed locally and are also integrated into the github workflow.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

This Databricks cluster module has only been tested with a Databricks cluster running on Azure cloud, other cloud providers (AWS or GCP) have not been tested (yet). Therefore, in the examples a Databricks workspace host url is retrieved from the AzureRM provider and set to the Databricks provider. 

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-db-cl/graphs/contributors).

## Contributing

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-db-cl/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/databricks)
- [Rest Api](https://docs.databricks.com/api/azure/workspace/clusters)
