#!/bin/bash

# this shell script should use PyTest to run unit tests on ETL apllication 
cd "/app/retail_etl"

# Use the conda executable from the correct environment to run
# running pytest (and the verbose option) will  
/opt/miniconda/envs/retail_etl/bin/pytest -v

# Capture the exit code immediately after pytest runs
exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo "All Unit Tests for ETL Application Code have Passed"
else
    echo "Some tests failed or an error occurred. Exit code: $exit_code"
fi

# EOF