# module for granting privileges on snowflake schemas to snowflake role groups 

resource "snowflake_schema_grant" "schema_privilege" {
  database_name     = var.database_name
  schema_name       = var.schema_name
  privilege         = var.privilege
  roles             = var.roles_to_grant_privilege
  with_grant_option = var.grant_option
}