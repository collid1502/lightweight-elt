# module for granting privileges on snowflake databases to snowflake role groups 
provider "snowflake" {
  username = var.snowflake_user
  password = var.snowflake_password
  account  = var.snowflake_account
  role     = var.snowflake_role
}

resource "snowflake_database_grant" "db_privilege" {
  database_name     = var.database_name
  privilege         = var.privilege
  roles             = var.roles_to_grant_privilege
  with_grant_option = var.grant_option 
}