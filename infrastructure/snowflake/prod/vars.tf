// set variables used in the infrastructure
variable "snowflake_user" {
  description = "User name to connect to Snowflake"
  type        = string
  default     = "sf_infra_srv_user"
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
  description = "Snowflake account identifier. Ideally sourced via environment variable TF_VAR_snowflake_account or similar."
  type        = string
}
