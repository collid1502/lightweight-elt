// This provider is required to ensure Terraform can work with snowflake to build infrastructure 
terraform {
  required_version = ">= 0.42.1"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.88.0"
    }
  }
}