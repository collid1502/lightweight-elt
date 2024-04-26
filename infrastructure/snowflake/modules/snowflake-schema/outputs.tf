// Specify outputs that could be useful for other resources or modules 
output "schema_name" {
  value       = snowflake_schema.create_schema.name
  description = "The name of the Snowflake schema created"
}
