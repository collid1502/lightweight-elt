// Specify outputs that could be useful for other resources or modules 
output "snowflake_schema_priv" {
  value       = snowflake_schema_grant.schema_privilege.privilege
  description = "The privilege granted to the role group"
}