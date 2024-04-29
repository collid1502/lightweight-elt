// Specify all the privileges that each role requires on what infra resource

// Both roles will require USAGE of the virtual WH
module "retail_wh_use" {
  source = "../../modules/snowflake-warehouse-privs"

  warehouse_name           = module.retail_etl_wh.warehouse_name // collects the warehouse name from the build_infra code
  privilege                = "USAGE"
  roles_to_grant_privilege = ["ETL_DEV", "RETAIL_ANALYST"] // specify the roles to grant the privilege to, in this case, reference roles created in build_roles
  grant_option             = false
}

// ETL DEVELOPER 
// For ETL developer, grant all privileges on Database
module "retail_db_etl_dev" {
  source = "../../modules/snowflake-database-privs"

  database_name            = module.customer_purchases_db.database_name // collects DB name from infra build 
  roles_to_grant_privilege = ["ETL_DEV"]
  privilege                = "ALL PRIVILEGES"
}

// ANALYST
// Analyst role requires Usage only for the Database 
module "retail_db_analyst" {
  source = "../../modules/snowflake-database-privs"

  database_name            = module.customer_purchases_db.database_name // collects DB name from infra build 
  roles_to_grant_privilege = ["RETAIL_ANALYST"]
  privilege                = "USAGE"
}


# --------------------------------------------------------------------
// Manage Schema Permissions 

// specify the schemas to grant privileges on for each Role Group 
locals {
  # specify the schemas to loop over & grant all privs on for ETL Developer role 
  etl_dev_schemas = [
    module.purchase_stg_schema.schema_name,
    module.purchase_schema.schema_name,
    module.purchase_analysis_schema.schema_name
  ]

  # specify the schemas that the analyst role should have access to   
  analyst_schemas = [
    module.purchase_schema.schema_name,
    module.purchase_analysis_schema.schema_name
  ]
  # specify the privilege type(s) the analyst should get on each schema 
  analyst_permissions = [
    "USAGE",
    "CREATE TEMPORARY TABLE"
  ]

  # use the `setproduct` which will allow you to iterate over the two lists, via every combination 
  analyst_grants = { for val in setproduct(local.analyst_schemas, local.analyst_permissions) :
  "${val[0]}-${val[1]}" => val }
}

// Grant privileges for ETL DEV
module "etl_dev_schema_privs" {
  source = "../../modules/snowflake-schema-privs"

  for_each = toset(local.etl_dev_schemas) // converts list to set for iteration 

  database_name            = module.customer_purchases_db.database_name // collects DB name from infra build 
  schema_name              = each.value                                 // represents each schema name in the list 
  privilege                = "ALL PRIVILEGES"
  roles_to_grant_privilege = ["ETL_DEV"]
  grant_option             = false
}

// Grant privileges for Retail Analyst 
module "retail_analyst_schema_privs" {
  source = "../../modules/snowflake-schema-privs"

  # loop over the map of schema & privs 
  for_each = local.analyst_grants

  database_name            = module.customer_purchases_db.database_name // collects DB name from infra build
  schema_name              = each.value[0]                              // represents each schema name in the map
  privilege                = each.value[1]                              // represents each privilege in the map 
  roles_to_grant_privilege = ["RETAIL_ANALYST"]
  grant_option             = false
}
