# module for granting privileges on snowflake warehouses to snowflake role groups 

resource "snowflake_warehouse_grant" "wh_privileges" {
  warehouse_name    = var.warehouse_name
  privilege         = var.privilege
  roles             = var.roles_to_grant_privilege
  with_grant_option = var.grant_option
}