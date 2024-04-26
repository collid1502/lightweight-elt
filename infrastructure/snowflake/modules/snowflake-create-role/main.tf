# module for creating snowflake role groups
provider "snowflake" {
  username = var.snowflake_user
  password = var.snowflake_password
  account  = var.snowflake_account
  role     = var.snowflake_role
}

// CREATE ROLE
resource "snowflake_role" "create_role" {
  name = var.role_name
}