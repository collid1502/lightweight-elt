// set variables required for the module

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