// This file will be used to create & manage roles within the project
// These roles will specify warehouse usage, and database & schema access for the role type

// CREATE ROLES 
// Create a role for ETL Developers
resource "snowflake_role" "etl_dev" {
  name = "ETL_DEV"
}

// Create a role for User Analysis
resource "snowflake_role" "user_analysis" {
  name = "USER_ANALYSIS"
}


// setup privileges for roles 
// start with the warehouse as both roles are the same 
resource "snowflake_warehouse_grant" "retail_warehouse_use" {
  warehouse_name = snowflake_warehouse.retail_etl.name
  privilege = "USAGE" 
  roles = [snowflake_role.etl_dev.name, snowflake_role.user_analysis.name]
  enable_multiple_grants = true
  with_grant_option = false
}

// database privs for user_analysis
resource "snowflake_database_grant" "retail_db_analysis_use" {
  database_name = snowflake_database.customer_purchases.name
  privilege = "USAGE"
  roles = [snowflake_role.user_analysis.name]
  enable_multiple_grants = true
  with_grant_option = false
}

// schema privs for user_analysis 
resource "snowflake_schema_grant" "retail_schema_analysis_use" {
  database_name = snowflake_database.customer_purchases.name
  schema_name   = snowflake_schema.purchase_data.name
  privilege = "USAGE"
  roles     = [snowflake_role.user_analysis.name]

  with_grant_option = false
}
resource "snowflake_schema_grant" "retail_schema_analysis_select" {
  database_name = snowflake_database.customer_purchases.name
  schema_name   = snowflake_schema.purchase_data.name
  privilege = "CREATE TEMPORARY TABLE" // can create a temp tabke for analysis in session 
  roles     = [snowflake_role.user_analysis.name]

  with_grant_option = false
}


// database privs for ETL DEV
resource "snowflake_database_grant" "retail_db_etl_dev" {
  database_name = snowflake_database.customer_purchases.name
  privilege = "ALL PRIVILEGES"
  roles = [snowflake_role.etl_dev.name]
  enable_multiple_grants = true
  with_grant_option = false
}

// schema privs for ETL dev on staging schema 
resource "snowflake_schema_grant" "retail_schema_etl_dev_stg" {
  database_name = snowflake_database.customer_purchases.name
  schema_name   = snowflake_schema.purchase_data_stg.name
  privilege = "ALL PRIVILEGES"
  roles     = [snowflake_role.etl_dev.name]

  with_grant_option = false
}

// schema privs for ETL dev on analysis schema 
resource "snowflake_schema_grant" "retail_schema_etl_dev" {
  database_name = snowflake_database.customer_purchases.name
  schema_name   = snowflake_schema.purchase_data.name
  privilege = "ALL PRIVILEGES"
  roles     = [snowflake_role.etl_dev.name]
 
  with_grant_option = false
}

// end 