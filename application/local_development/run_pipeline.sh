#!/bin/bash

# This is a script to run the pipeline stages of Python, Snowpark & DBT
# which in turn creates the data products for the Customer Purchases data

# Start by switching into the dir that contains the Python code
cd "/home/ec2-user/work/lightweight-elt/application/local_development/src/retail_sourcing"
if [ $? -ne 0 ]; then
    echo "Failed to change directory to Python code location."
    exit 1
fi

# Use the conda executable from the correct environment to run the relevant Python code 
~/miniconda3/envs/retail_etl_dev/bin/python app.py 
if [ $? -ne 0 ]; then
    echo "Python script failed to execute."
    exit 1
fi

# Switch now to the DBT project directory 
cd "/home/ec2-user/work/lightweight-elt/application/local_development/src/retail_modelling/customer_purchases"
if [ $? -ne 0 ]; then
    echo "Failed to change directory to DBT project location."
    exit 1
fi

# Run the DBT build 
# Use the conda executable from the correct environment to run the relevant DBT project 
~/miniconda3/envs/retail_etl_dev/bin/dbt build
if [ $? -ne 0 ]; then
    echo "DBT build failed."
    exit 1
fi

# Return home to work dir 
cd "/home/ec2-user/work" 
if [ $? -ne 0 ]; then
    echo "Failed to return to the home directory."
    exit 1
fi

echo "All tasks completed successfully."
# EOF