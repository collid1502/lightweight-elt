# module for creating snowflake databases

// Create a new database in Snowflake
resource "snowflake_database" "create_database" {
  name    = var.database_name
  comment = var.comment

  # lifecycle {
  #   prevent_destroy = var.prevent_destroy
  # }
}
