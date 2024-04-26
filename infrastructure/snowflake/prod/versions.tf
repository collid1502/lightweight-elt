// This provider is required to ensure Terraform can work with snowflake to build infrastructure 
terraform {
  required_version = ">= 1.2.7" // specifies that at least version 1.2.7 of Terraform must be used

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.88.0" // Ensures use of snowflake provider version 0.88.0 with Terraform 1.2.7 (at least) 
    }
  }
}