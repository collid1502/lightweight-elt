#!/bin/bash  

# This script is designed to use the AWS CLI to push Docker images into an AWS ECR repo
# That repo will have been created through Terraform 

# change to the directory where the dockerfile is, and build the image
#cd ./application/docker/

# Authenticate Docker to ECR on AWS 
# The aws ecr get-login-password command itself retrieves a temporary authentication token from AWS, 
# which means you don't have to manually provide a password. This token is then piped to the docker login command. 
# This way, you're not manually inputting any credentials, but rather using the credentials configured with aws 
# configure to obtain the temporary token.
# aws ecr get-login-password --region $TF_VAR_AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCT_ID.dkr.ecr.$TF_VAR_AWS_DEFAULT_REGION.amazonaws.com 
aws ecr \
    get-login-password --region $TF_VAR_AWS_DEFAULT_REGION | docker login --username \
    AWS --password-stdin $AWS_ACCT_ID.dkr.ecr.$TF_VAR_AWS_DEFAULT_REGION.amazonaws.com

# By following these steps, you are using the AWS CLI to securely obtain a temporary authentication token for 
# Docker without manually providing a password

# build the image (if needed)
# docker build \
#     --build-arg snowflake_account=$snowflake_account \
#     --build-arg etl_serv_password=$etl_serv_password \
#     -t retail_etl_app:aws_v1 -f ./dockerfile .

# tag it with the aws ecr repo URI
docker tag retail_etl_app:aws_v1 $AWS_ACCT_ID.dkr.ecr.$TF_VAR_AWS_DEFAULT_REGION.amazonaws.com/retail-de-repo:etl_app_v1

# now, push that image to ECR
docker push $AWS_ACCT_ID.dkr.ecr.$TF_VAR_AWS_DEFAULT_REGION.amazonaws.com/retail-de-repo:etl_app_v1

cd ..
cd ..
# Now, log into the AWS console & check the private repository to see oif the docker image had been uploaded