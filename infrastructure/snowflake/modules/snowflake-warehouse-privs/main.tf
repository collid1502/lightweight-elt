# module for granting privileges on snowflake warehouses to snowflake role groups 
provider "snowflake" {
  username = var.snowflake_user
  password = var.snowflake_password
  account  = var.snowflake_account
  role     = var.snowflake_role
}

resource "snowflake_warehouse_grant" "wh_privileges" {
  warehouse_name    = var.warehouse_name
  privilege         = var.privilege
  roles             = var.roles_to_grant_privilege
  with_grant_option = var.grant_option 
}