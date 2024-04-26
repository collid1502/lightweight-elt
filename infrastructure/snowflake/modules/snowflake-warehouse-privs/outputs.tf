// Specify outputs that could be useful for other resources or modules 
output "snowflake_wh_priv" {
  value       = snowflake_warehouse_grant.wh_privileges.privilege 
  description = "The privilege granted to the role group"
}