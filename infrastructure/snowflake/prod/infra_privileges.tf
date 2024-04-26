// Specify all the privileges that each role requires on what infra resource

// Both roles will require USAGE of the virtual WH
module "retail_wh_use" {
    source = "../modules/snowflake-warehouse-privs" 

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra 

    warehouse_name = module.retail_etl_wh.warehouse_name // collects the warehouse name from the build_infra code
    privilege = "USAGE"  
    roles_to_grant_privilege = [module.etl_developer.role_name, module.retail_analyst_user.role_name] // specify the roles to grant the privilege to, in this case, reference roles created in build_roles
    grant_option = false 
}

// ETL DEVELOPER 
// For ETL developer, grant all privileges on Database
module "retail_db_etl_dev" {
    source = "../modules/snowflake-database-privs" 

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra 

    database_name = module.customer_purchases_db.database_name // collects DB name from infra build 
    roles_to_grant_privilege = [module.etl_developer.role_name]
    privilege = "ALL PRIVILEGES"
}

// ANALYST
// Analyst role requires Usage only for the Database 
module "retail_db_analyst" {
    source = "../modules/snowflake-database-privs" 

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra 

    database_name = module.customer_purchases_db.database_name // collects DB name from infra build 
    roles_to_grant_privilege = [module.retail_analyst_user.role_name]
    privilege = "USAGE"
}


# --------------------------------------------------------------------
// Manage Schema Permissions 

NOTES - Update to modules required to remove local provider configs in order for for_each to work


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
  analyst_permissions = ["USAGE", "CREATE TEMPORARY TABLE"]
  # create a map (dictionary) of the two, which will allow for iteration over both schema & privilege 
  # for example: 'schema_name' : 'privilege' & that way, you can use the `key` & the `value` in the for loop
  analyst_grants = {for id in range(length(local.analyst_schemas)) :
        local.analyst_schemas[id] => local.analyst_permissions[id]
    }
}

// Grant privileges for ETL DEV
module "etl_dev_schema_privs" {
    source = "../modules/snowflake-schema-privs"

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra

    for_each = toset(local.etl_dev_schemas) // converts list to set for iteration 

    database_name = module.customer_purchases_db.database_name // collects DB name from infra build 
    schema_name = each.value // represents each schema name in the list 
    privilege = "ALL PRIVILEGES"
    roles_to_grant_privilege = [module.etl_developer.role_name] 
    grant_option = false
}

// Grant privileges for Retail Analyst 
module "retail_analyst_schema_privs" {
    source = "../modules/snowflake-schema-privs" 

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra

    # loop over the map of schema & privs 
    for_each = local.analyst_grants

    database_name = module.customer_purchases_db.database_name // collects DB name from infra build
    schema_name = each.key // represents each schema name in the map
    privilege = each.value // represents each privilege in the map 
    roles_to_grant_privilege = [module.retail_analyst_user.role_name] 
    grant_option = false
}
