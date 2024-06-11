# This resource is used to create the Service Acct User & assign permission

# create the user 
resource "snowflake_user" "ETL_SERV_USER" {
  name     = "ETL_SERV_ACCT"
  password = var.etl_serv_password

  must_change_password = false # no requirement for the service acct to change password at first login 
  comment              = "Service Acct user for Data Engineer team to perform ETL/ELT and Data Modelling with snowflake resources"
  // Other required user settings
}

# grant the `ETL_DEV` role to the above user 
resource "snowflake_role_grants" "etl_serv_grant" {
  role_name = "ETL_DEV"

  enable_multiple_grants = true # When this is set to true, multiple grants of the same type can be created. 
  # This will cause Terraform to not revoke grants applied to roles and objects outside Terraform
  # assign the role to the following users
  users = [
    snowflake_user.ETL_SERV_USER.name
  ]
}

# end 