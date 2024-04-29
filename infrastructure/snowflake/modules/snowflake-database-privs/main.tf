# module for granting privileges on snowflake databases to snowflake role groups 

resource "snowflake_database_grant" "db_privilege" {
  database_name     = var.database_name
  privilege         = var.privilege
  roles             = var.roles_to_grant_privilege
  with_grant_option = var.grant_option
}