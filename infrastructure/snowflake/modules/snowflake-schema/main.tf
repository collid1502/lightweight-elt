# module for creating snowflake schemas within a database

// Inside that new database, create a new schema in the database for STAGING data
resource "snowflake_schema" "create_schema" {
  name     = var.schema_name
  database = var.database_name
  comment  = var.comment
}
