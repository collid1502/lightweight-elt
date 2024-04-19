# creating variables and theyre values for terraform to use
variable "ACCOUNT" {
  type        = string
  description = "The Snowflake account identifier. Sourced via environment variable TF_VAR_ACCOUNT."
}

variable "SNOWFLAKE_USER" {
  type        = string
  description = "The username for the Snowflake connection."
  default = "sf_infra_srv_user" // This is a default value that will be used for this variable 
}

variable "PASSWORD" {
  type        = string
  description = "The password for the Snowflake connection. Sourced via environment variable TF_VAR_PASSWORD."
  sensitive   = true
}
