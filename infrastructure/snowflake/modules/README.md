# Terraform modules for Snowflake

Modules can prove extremely useful in terraform, as they let you re-use code easily for infrastructure, simply changing variables dependent upon your needs.

There will be the following modules:

* snowflake-warehouse
* snowflake-database
* snowflake-schema
* snowflake-create-role
* snowflake-warehouse-privs
* snowflake-database-privs
* snowflake-schema-privs


These modules can then be called by our Terraform code to build different environments and infrastructure where needed