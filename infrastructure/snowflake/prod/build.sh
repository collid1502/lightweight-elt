#!/bin/bash

# build Terraform resources one by one (note, only action these having checked elements)

# ensure formatting in all .tf files (in all sub-dirs)
terraform fmt -recursive

# run Roles
cd ./roles 
terraform validate
terraform plan 
terraform apply -auto-approve 

# now run Resources 
cd ..
cd ./resources
terraform validate
terraform plan 
terraform apply -auto-approve 

# now run Users 
cd ..
cd ./users
terraform validate 
terraform plan
terraform apply -auto-approve 

cd .. # back to main folder 