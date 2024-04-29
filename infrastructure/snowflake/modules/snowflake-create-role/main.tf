# module for creating snowflake role groups

// CREATE ROLE
resource "snowflake_role" "create_role" {
  name = var.role_name
}