#!/bin/bash  

# authenticate
aws ecr \
    get-login-password --region $TF_VAR_AWS_DEFAULT_REGION | docker login --username \
    AWS --password-stdin $AWS_ACCT_ID.dkr.ecr.$TF_VAR_AWS_DEFAULT_REGION.amazonaws.com

# delete image based on tag
aws ecr batch-delete-image --repository-name retail-de-repo \
    --image-ids imageTag=etl_app_v1 --region $TF_VAR_AWS_DEFAULT_REGION

# eof