#!/bin/bash  

# name of environment to check, remove & then rebuild as required
ENV_NAME="retail_etl_dev"

# Check if the environment exists
echo "Checking if Conda environment '$ENV_NAME' already exists ..."
conda env list | grep -qw $ENV_NAME

# Check the exit status of the grep command
if [ $? -eq 0 ]; then
    echo "Environment '$ENV_NAME' exists. Removing..."
    # execute the removal with auto approval 
    conda env remove --name $ENV_NAME --yes
    echo "Environment '$ENV_NAME' removed."
else
    echo "Environment '$ENV_NAME' does not exist. No action taken."
fi
echo ""

# For Bash
#source ~/miniconda3/etc/profile.d/conda.sh

# Now, build a new conda environment for this project
# the --yes will auto approve any prompt
conda create --name $ENV_NAME python=3.9 pip numpy pandas --yes 

# activate that environment
conda activate $ENV_NAME 

# Within that conda env, pip install required libs (this is because conda doesnt seem to have all, but PyPi does)
# Install DBT & it's required packages for Snowflake into the virtual environment
pip install pyyaml datetime cuallee duckdb datetime faker \
    pytest "snowflake-snowpark-python[pandas]" install dbt-core dbt-snowflake

# deactivate environment once installs complete
conda deactivate

echo ""

# check environment exists again ...
conda env list | grep -qw $ENV_NAME

# Check the exit status of the grep command
if [ $? -eq 0 ]; then
    echo "Environment '$ENV_NAME' built"
else
    echo "Environment '$ENV_NAME' does not exist. Error in build."
fi

# EOF