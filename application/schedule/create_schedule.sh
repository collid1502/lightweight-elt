#!/bin/bash  

# Use AWS CLI to create a "step-function" that can trigger the AWS Batch job
aws stepfunctions create-state-machine --name Retail_Batch_ELT \
    --definition file://step_function_definition.json \
    --role-arn arn:aws:iam::503289723064:role/AWSBatchServiceRole

# create an event bridge rule to trigger the step function (aka the cron schedule)
aws events put-rule \
    --name Retail_ELT_Batch_Rule \
    --schedule-expression "cron(38 * * * ? *)" \
    --role-arn arn:aws:iam::503289723064:role/AWSBatchServiceRole


# add target for event bridge rule to trigger (tell the rule above to trigger the step function)
aws events put-targets \
    --rule Retail_ELT_Batch_Rule \
    --targets '[
            {
                "Id": "1",
                "Arn": "arn:aws:states:eu-west-2:503289723064:stateMachine:Retail_Batch_ELT",
                "RoleArn": "arn:aws:iam::503289723064:role/AWSBatchServiceRole"
            }
        ]'

# end 