# module for creating snowflake warehouses
provider "snowflake" {
  username = var.snowflake_user
  password = var.snowflake_password
  account  = var.snowflake_account
  role     = var.snowflake_role
}

resource "snowflake_warehouse" "create_warehouse" {
  name                         = var.warehouse_name
  warehouse_size               = var.warehouse_size // x-small, small, medium, large, x-large ... etc 
  auto_suspend                 = var.auto_suspend
  auto_resume                  = var.auto_resume
  initially_suspended          = var.initially_suspended          // will leave the warehouse in suspended state upon creation
  statement_timeout_in_seconds = var.statement_timeout_in_seconds // Max query run time set in seconds. Default is 172,800 (2 days)
  comment                      = var.comment
}
