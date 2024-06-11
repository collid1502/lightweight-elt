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
  default     = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra
}

variable "snowflake_account" {
  description = "Snowflake account identifier. Ideally sourced via environment variable TF_VAR_snowflake_account or similar."
  type        = string
}

# will be sourced from environment variables (in ~/.bashrc) TF_VAR_etl_serv_password or provided as input via prompt
variable "etl_serv_password" {
  description = "Snowflake password for the service account we create that can run the ETL processes"
  type        = string
  sensitive   = true
}
