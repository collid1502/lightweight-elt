// Specify outputs that could be useful for other resources or modules 
output "snowflake_role_name" {
  value       = snowflake_role.create_role.name
  description = "The name of the Snowflake role group created"
}
