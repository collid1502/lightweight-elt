#!/bin/bash  

# ensure formatting in all .tf files
terraform fmt -recursive

# creates AWS Resources through Terraform
terraform validate
terraform plan 
terraform apply -auto-approve 
