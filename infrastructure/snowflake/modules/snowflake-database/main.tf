# module for creating snowflake databases
provider "snowflake" {
  username = var.snowflake_user
  password = var.snowflake_password
  account  = var.snowflake_account
  role     = var.snowflake_role
}

// Create a new database in Snowflake
resource "snowflake_database" "create_database" {
  name    = var.database_name 
  comment = var.comment

  # lifecycle {
  #   prevent_destroy = var.prevent_destroy
  # }
}
