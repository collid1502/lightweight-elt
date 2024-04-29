// set variables required for the module
variable "database_name" {
  description = "Name of the database to be created"
  type        = string
}

variable "comment" {
  description = "Comment for the newly created database that can provide some context or detail"
  type        = string
  default     = ""
}

# variable "prevent_destroy" {
#   description = "Prevent accidental destruction of the database"
#   type        = bool
#   default     = true
# }