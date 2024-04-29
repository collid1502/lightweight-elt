// set variables required for the module

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