// This file will be used to create the snowflake infrastructure for the project

// specify the provider & connection details 
provider "snowflake" {
  account  = var.ACCOUNT
  username = var.SNOWFLAKE_USER
  password = var.PASSWORD
  role     = "infra_admin"  // This role needs sufficient privileges
}

// Create a new warehouse in Snowflake. Call it `retail_etl` as it will be used for performing the transformations 
// on snowflake, once raw data has been passed there
resource "snowflake_warehouse" "retail_etl" {
  name           = "RETAIL_ETL"
  warehouse_size = "XSMALL" // extra-small warehouse to start is fine 
  //warehouse_type = "STANDARD" // You can choose "SNOWPARK-OPTIMIZED" if the warehouse will be used for heavy snowpark activity and is bigger than SMALL
  //min_cluster_count = 1 // specify the minimum number of clusters for a multi-cluster warehouse (default is 1)
  //max_cluster_count = 1 // specify the maximum  number of clusters for a multi-cluster warehouse (default is 1) 
  //scaling_policy = "STANDARD" // Standard minimizes queing by starting clusters, economy tries to favour running clusters fully loaded before starting a new one
  auto_suspend   = 120 // Specifies number of seconds after inactivity on warehouse that it suspends. Min 60. Default 600. 
  auto_resume    = true // auto resume upon a query executed via the warehouse 
  statement_timeout_in_seconds = 10800 // Max query run time set to 3hrs (10,800 seconds). Default is 172,800 (2 days) 
  initially_suspended = true // will leave the warehouse in suspended state upon creation 
  comment = "This is a warehouse for processing the transformations of raw customer data into the relevant tables" 
}

// Create a new database in Snowflake. This database will be called `customer_purchases` 
resource "snowflake_database" "customer_purchases" {
  name = "CUSTOMER_PURCHASES"
}

// Inside that new database, create a new schema in the database for STAGING data
resource "snowflake_schema" "purchase_data_stg" {
  name         = "PURCHASE_DATA_STG"
  database     = snowflake_database.customer_purchases.name // uses the name attribute from the DB resource above 
  comment      = "A schema that will hold staging data pre-transformation for customer purchases"
}
// Create another for the analytical output layer 
resource "snowflake_schema" "purchase_data" {
  name         = "PURCHASE_DATA"
  database     = snowflake_database.customer_purchases.name // uses the name attribute from the DB resource above 
  comment      = "A schema that will hold transformed & modelled data for customer purchases"
}

# Output the created resources' names
output "warehouse_name" {
  value = snowflake_warehouse.retail_etl.name
}

output "database_name" {
  value = snowflake_database.customer_purchases.name
}

output "staging_schema_name" {
  value = snowflake_schema.purchase_data_stg.name
}

output "analytics_schema_name" {
  value = snowflake_schema.purchase_data.name
}

// end 