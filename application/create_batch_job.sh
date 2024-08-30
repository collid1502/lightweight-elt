#!/bin/bash  

# This script is designed to create a AWS batch job to run on the AWS compute environment we 
# created as part of the AWS infrastructure via Terraform 

# stage 1 - Create a Job Definition which uses the Docker Image uploaded to AWS ECR
aws batch register-job-definition \
    --job-definition-name retail-de-elt \
    --type container \
    --platform-capabilities FARGATE \
    --container-properties '{
        "image": "'"$AWS_ACCT_ID"'.dkr.ecr.'"$TF_VAR_AWS_DEFAULT_REGION"'.amazonaws.com/retail-de-repo:etl_app_v1", 
        "resourceRequirements": [
                {"type": "VCPU", "value": "4"},
                {"type": "MEMORY", "value": "10240"}
            ],
        "command": ["bash", "-c", "/app/run_pipeline.sh"],
        "jobRoleArn": "arn:aws:iam::503289723064:role/AWSBatchServiceRole",
        "executionRoleArn": "arn:aws:iam::503289723064:role/AWSBatchServiceRole",
        "networkConfiguration": {
            "assignPublicIp": "ENABLED"
        },
        "fargatePlatformConfiguration": {
            "platformVersion": "LATEST"
        }
    }'

# the above, specifies a job-def which is a container so will use a docker image 
# we specify the image by providing the link to our image stored in AWS ECR 
# specify the number of VCPUs & memory
# the command section is where we specify, run the container, and then use `bash` to run this .sh script in the container

# The jobRoleArn parameter in the aws batch register-job-definition command specifies the Amazon Resource Name (ARN) 
# of the AWS Identity and Access Management (IAM) role that is associated with the job. This role is used by AWS Batch 
# to grant the job the necessary permissions to interact with other AWS services during its execution.
# we created this during the Terraform infra build 