// Specify outputs that could be useful for other resources or modules 
output "warehouse_name" {
  value       = snowflake_warehouse.create_warehouse.name
  description = "The name of the Snowflake warehouse"
}