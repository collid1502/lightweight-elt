#!/bin/bash  

# Start by targeting ECR & AWS Batch for destruction first, as they need IAM roles in order to do this
# You can do this with the target option 

# destroy the aws batch compute environment
terraform destroy --target aws_batch_compute_environment.retail_batch_env -auto-approve

# destroy the ECR repository of docker images 
terraform destroy --target aws_ecr_repository.Retail_DE_Repository -auto-approve

# destroy all other IaC on AWS by Terraform
terraform destroy -auto-approve 

echo ""
echo "=============================================="
echo "All resources have been successfully destroyed"
echo "=============================================="