# Create an Elastic Container Registry on AWS which can store our Docker Images
# default setting is to create a PRIVATE ECR, which is what we want to securely manage images 
resource "aws_ecr_repository" "Retail_DE_Repository" {
  name                 = "retail-de-repo"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "Retail_DE_Repository"
  }
}

# This resource defines the lifecycle policy for the ECR repository
# The JSON-formatted lifecycle policy defines rules for retaining or deleting images. 
# In this case, it keeps the last 3 images and deletes older versions
resource "aws_ecr_lifecycle_policy" "Retail_DE_Lifecycle_Policy" {
  repository = aws_ecr_repository.Retail_DE_Repository.name

  // rulePriority: The priority of the rule, where 1 is the highest priority.
  // action: Specifies the action to take. expire indicates that the selected images should be deleted.
  // tagStatus: any means it applies to all images, regardless of their tag status.
  // countType: imageCountMoreThan specifies that it applies when there are more than a certain number of images.
  // countNumber: This sets the threshold to keep. For example, the latest 10 images will be retained.
  // anyTag: Whether to apply the rule to any image tag.
  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 3 images, delete older versions",
      "selection": {
        "tagStatus": "any", 
        "countType": "imageCountMoreThan",
        "countNumber": 3
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
