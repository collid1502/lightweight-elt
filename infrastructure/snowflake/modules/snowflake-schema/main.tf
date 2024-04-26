# module for creating snowflake schemas within a database
provider "snowflake" {
  username = var.snowflake_user
  password = var.snowflake_password
  account  = var.snowflake_account
  role     = var.snowflake_role
}

// Inside that new database, create a new schema in the database for STAGING data
resource "snowflake_schema" "create_schema" {
  name         = var.schema_name
  database     = var.database_name 
  comment      = var.comment
}
