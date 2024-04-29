// Create the different role groups that will be needed

module "etl_developer" {
  source = "../../modules/snowflake-create-role"

  role_name = "ETL_DEV"
}

module "retail_analyst_user" {
  source = "../../modules/snowflake-create-role"

  role_name = "RETAIL_ANALYST"
}
