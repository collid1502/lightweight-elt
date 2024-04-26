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

variable "schema_name" {
  description = "Name of the schema to be created"
  type        = string
}

variable "database_name" {
  description = "Name of the database to be use for schema to be created in"
  type        = string
}

variable "comment" {
  description = "Comment for the newly created schema that can provide some context or detail"
  type        = string
  default     = ""
}