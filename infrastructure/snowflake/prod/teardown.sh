#!/bin/bash

# detstroy all IaC on Snowflake by Terraform

# run Roles
cd ./roles 
terraform destroy -auto-approve 

# now run Resources 
cd ..
cd ./resources
terraform destroy -auto-approve 

# now run Users 
cd ..
cd ./users
terraform destroy -auto-approve 

cd .. # back to main folder 
echo ""
echo "========================================================="
echo "All Snowflake resources have been successfully destroyed"
echo "========================================================="