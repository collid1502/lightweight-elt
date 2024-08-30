// Make sure the IAM role you assign to service_role has the necessary permissions for Fargate

# The aws_iam_role resource creates an IAM role named AWSBatchServiceRole. 
# This role will be assumed by the AWS Batch service
resource "aws_iam_role" "batch_service_role" {
  name = "AWSBatchServiceRole"

  assume_role_policy = jsonencode({ // The assume_role_policy is a JSON document that specifies who or what can assume this role
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole" // sts:AssumeRole allows the specified service to assume the role
        Effect = "Allow"          // Set to Allow, permitting the action specified
        Principal = {
          Service = "batch.amazonaws.com" // In this case, the principal is batch.amazonaws.com, which means that the AWS Batch service can assume this role
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "scheduler.amazonaws.com" // This builds a trust relationship for AWS EventBridge to execute the AWS Batch
        },
        "Action" : "sts:AssumeRole"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs.amazonaws.com" // Allows ECS to assume the AWS Batch role via Trust an execute as required
        },
        "Action" : "sts:AssumeRole"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com" // Allows ECS tasks permission to assume AWS Batch role
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# resource attaches a managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "batch_full_policy" {
  role       = aws_iam_role.batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBatchFullAccess"
}
# The policy_arn is the Amazon Resource Name (ARN) of the AWS managed policy . 
# This policy grants the AWS Batch service the full permissions it needs to operate, such as the ability to 
# create and manage resources like ECS clusters, tasks, and job definitions

# resource attaches a managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "batch_ecr_read_policy" {
  role       = aws_iam_role.batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
# this policy is so the AWS Batch role has permission to read images from an ECR repo on AWS 

# resource attaches a managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "batch_cloudwatch_policy" {
  role       = aws_iam_role.batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
# this policy is so the AWS Batch role has permission to have full access on cloud watch logs 


resource "aws_iam_role_policy_attachment" "ecs_admin_role_policy" {
  role       = aws_iam_role.batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
# This policy is attached to the same IAM role, and it provides permissions necessary for ECS tasks
# such as :
# Pull images: Download container images from Amazon ECR or other registries
# Log to CloudWatch: Send log information to Amazon CloudWatch Logs
# Interact with other AWS services: Depending on the needs of your tasks, such as accessing S3 or secrets in AWS Secrets Manager

# This policy is essential when using Fargate (or ECS) because it allows the containers that are launched by AWS Batch to 
# function properly, including the ability to retrieve necessary configurations, secrets, and other resources




# creation of custom IAM policy for ECS actions 
# resource "aws_iam_policy" "custom_ecs_policy" {
#   name        = "CustomECSPolicy"
#   description = "Custom policy to allow ECS cluster creation and listing"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "ecs:CreateCluster",
#           "ecs:ListClusters",
#           "ecs:DescribeClusters",
#           "ecs:DeleteCluster"
#         ],
#         Resource = ["*"]
#       }
#     ]
#   })
# }
# // attach it 
# resource "aws_iam_role_policy_attachment" "attach_custom_ecs_policy" {
#   role       = aws_iam_role.batch_service_role.name # Replace with your role name
#   policy_arn = aws_iam_policy.custom_ecs_policy.arn
# }
