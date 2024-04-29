// set variables required for the module

variable "warehouse_name" {
  description = "Name of the Snowflake warehouse"
  type        = string
}

variable "warehouse_size" {
  description = "Size of the Snowflake warehouse"
  type        = string
  default     = "X-SMALL" // This default Value is used if no values are specified when calling module 
}

variable "auto_suspend" {
  description = "Time in seconds of inactivity before the warehouse is suspended"
  type        = number
  default     = 120 // This default Value is used if no values are specified when calling module 
}

variable "auto_resume" {
  description = "Specifies if the warehouse should be automatically resumed"
  type        = bool
  default     = true // This default Value is used if no values are specified when calling module
}

variable "initially_suspended" {
  description = "Specifies if the warehouse should be initially suspended at creation, until a query is ran"
  type        = bool
  default     = true // This default Value is used if no values are specified when calling module
}

variable "statement_timeout_in_seconds" {
  description = "Specifies the maximum time in seconds a query can run for on the warehouse before it hits timeout & aborts"
  type        = number
  default     = 10800 // This default Value is used if no values are specified when calling module. Max query run time set to 3hrs (10,800 seconds).
}

variable "comment" {
  description = "Comment associated with the warehouse"
  type        = string
  default     = "No Comment Provided" // This default Value is used if no values are specified when calling module
}