#!/bin/bash

# This is a script to run the pipeline stages of Python, Snowpark & DBT
# which in turn creates the data products for the Customer Purchases data

# Start by switching into the work dir that the dockerfile created
cd "/app/retail_etl"
if [ $? -ne 0 ]; then
    echo "Failed to change directory to ETL application location."
    exit 1
fi

# Use the conda executable from the correct environment to run the relevant Python code 
/opt/miniconda/envs/retail_etl/bin/python app.py
if [ $? -ne 0 ]; then
    echo "Python script failed to execute."
    exit 1
fi

# Switch now to the DBT project directory (ELT)
cd "/app/retail_elt/customer_purchases"
if [ $? -ne 0 ]; then
    echo "Failed to change directory to DBT project location."
    exit 1
fi

# Run the DBT build 
# Use the conda executable from the correct environment to run the relevant DBT project 
/opt/miniconda/envs/retail_etl/bin/dbt build --profiles-dir $DBT_PROFILES_DIR
if [ $? -ne 0 ]; then
    echo "DBT build failed."
    exit 1
fi

# Return home to app dir 
cd "/app" 
if [ $? -ne 0 ]; then
    echo "Failed to return to the app directory"
    exit 1
fi

echo "All tasks completed successfully."
# EOF