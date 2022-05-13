locals {
  big_query_datasets = jsondecode(replace(file("${path.module}/../deployment/big-query/big-query-datasets.json"), "$ENV", var.env))
  big_query_datasets_tables_with_bindings = {
    for dataset_manifest in flatten([
      # Loop on dataset
      for dataset_id, dataset in local.big_query_datasets : {
        dataset_id = dataset_id
        # Rewrite iam_bindings from the tables of a dataset
        iam_binding_table = merge(dataset, tomap(
          {
            tables = {
              for table_manifest in flatten([
                # Loop on each table
                for table_id, table in dataset.tables : {
                  table_id = table_id
                  table    = table
                  # Prepare elements from "common" and "env"
                  common      = lookup(lookup(table, "iam_bindings", {}), "common", {})
                  environment = lookup(lookup(table, "iam_bindings", {}), var.env, {})
                }
                ]) : table_manifest.table_id => merge(table_manifest.table, tomap(
                {
                  iam_bindings = {
                    # Merge Role from "common" and "env" with setunion() in order to produce a single set containing the elements from all of the given sets.
                    for role_id in setunion(keys(table_manifest.common), keys(table_manifest.environment)) :
                    # Merge Members from the same role with setunion()
                    role_id => setunion(lookup(table_manifest.common, role_id, []), lookup(table_manifest.environment, role_id, []))
                  }
                }
              ))
            }
          }
        ))
        common      = lookup(lookup(dataset, "iam_bindings", {}), "common", {})
        environment = lookup(lookup(dataset, "iam_bindings", {}), var.env, {})
      }
      ]) : dataset_manifest.dataset_id => merge(dataset_manifest.iam_binding_table, tomap(
      {
        # Same for Dataset
        iam_bindings = {
          for role_id in setunion(keys(dataset_manifest.common), keys(dataset_manifest.environment)) :
          role_id => setunion(lookup(dataset_manifest.common, role_id, []), lookup(dataset_manifest.environment, role_id, []))
        }
      }
    ))
  }
}


module "big_query" {
  source   = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.bigquery/?ref=0.42.2"
  project  = var.project_id
  datasets = local.big_query_datasets_tables_with_bindings
}
