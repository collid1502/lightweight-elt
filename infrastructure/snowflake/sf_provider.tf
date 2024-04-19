// This provider is required to ensure Terraform can work with snowflake to build infrastructure 
terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.88.0"  // Specify the version you want to use
    }
  }
}

// end 