// set variables required for the module
variable "snowflake_user" {
  description = "User name to connect to Snowflake"
  type        = string
}

variable "snowflake_password" {
  description = "Password to connect to Snowflake. Ideally sourced via environment variable TF_VAR_snowflake_password or similar."
  type        = string
  sensitive   = true
}

variable "snowflake_role" {
  description = "Role to use in Snowflake"
  type        = string
}

variable "snowflake_account" {
  description = "Snowflake account identifier. Ideally sourced via environment variable TF_VAR_snowflake_password or similar."
  type        = string
}

variable "database_name" {
  description = "Name of the database that schema sits in"
  type        = string
}

variable "schema_name" {
  description = "Name of the schema to grant privileges on"
  type        = string
}

variable "privilege" {
  description = "Name of the privilege to grant"
  type        = string
  default     = "USAGE" // basic priv, but overridden as needed when module called 
}

variable "roles_to_grant_privilege" {
  description = "A list of roles to grant privileges on the warehouse"
  type        = list(string)
  default     = []
}

variable "grant_option" {
  description = "Whether to extend a forwarding grant option alongside the privilege being granted"
  type        = bool
  default     = false 
}