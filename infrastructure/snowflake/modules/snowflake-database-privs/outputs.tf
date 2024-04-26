// Specify outputs that could be useful for other resources or modules 
output "snowflake_database_priv" {
  value       = snowflake_database_grant.db_privilege.privilege 
  description = "The privilege granted to the role group"
}