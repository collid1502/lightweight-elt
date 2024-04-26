// Create the different role groups that will be needed

module "etl_developer" {
    source = "../modules/snowflake-create-role" 

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra 

    role_name = "ETL_DEV"
}

module "retail_analyst_user" {
    source = "../modules/snowflake-create-role"

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra 

    role_name = "RETAIL_ANALYST" 
}
