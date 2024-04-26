// Create the infrastructure for our snowflake resources in this project

// use snowflake-warehouse module to create a warehouse to run the compute 
module "retail_etl_wh" {
    source = "../modules/snowflake-warehouse" // module to use for the resource build 

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra 

    warehouse_name = "RETAIL_ETL_WH" // Specify name of the virtual warehouse 
    warehouse_size = "XSMALL" // Extra-Small is fine for this projects data volumes 
    auto_suspend   = 120 // suspend warehouse after 120 seconds of inactivity 
    auto_resume    = true // allows warehouse to auto-resume upon query submission 
    statement_timeout_in_seconds = 10800 // Timeout any query after 3hrs execution 
    initially_suspended = true // Upon creation, warehouse will be in suspended mode
    comment = "This is a warehouse for processing the transformations of raw customer data into the relevant tables"
} 

// create a database for customer purchases data
module "customer_purchases_db" {
    source = "../modules/snowflake-database" // module to use for resource build 

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra

    database_name = "CUSTOMER_PURCHASES" 
    comment       = "Database for holding data relating to customer purchase activity"
}

// create a staging schema, cleaned data model schema & analytics schema
// STAGING
module "purchase_stg_schema" {
    source = "../modules/snowflake-schema"

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra

    database_name = module.customer_purchases_db.database_name // This will collect the name of the database created above
    schema_name = "PURCHASE_DATA_STG"
    comment = "Schema to hold raw data in snowflake, ready for transformation to clean model"
}
// MODELLED
module "purchase_schema" {
    source = "../modules/snowflake-schema"

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra

    database_name = module.customer_purchases_db.database_name // This will collect the name of the database created above
    schema_name = "PURCHASE_DATA"
    comment = "Schema to hold modelled data in snowflake, ready for querying & analysis"
}
// SUMMARY ANALYSIS MODELS
module "purchase_analysis_schema" {
    source = "../modules/snowflake-schema"

    snowflake_user = var.snowflake_user
    snowflake_password = var.snowflake_password
    snowflake_account = var.snowflake_account
    snowflake_role = "infra_admin" // This is the role-group that the user has sufficient privs with to build infra

    database_name = module.customer_purchases_db.database_name // This will collect the name of the database created above
    schema_name = "PURCHASE_ANALYTICS"
    comment = "Schema to hold analytical models from clean purchases data"
}
