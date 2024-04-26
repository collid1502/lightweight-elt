// Specify outputs that could be useful for other resources or modules 
output "database_name" {
  value       = snowflake_database.create_database.name
  description = "The name of the Snowflake database"
}