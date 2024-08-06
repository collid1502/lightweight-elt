# Create an Elastic Container Registry on AWS which can store our Docker Images
# default setting is to create a PRIVATE ECR, which is what we want to securely manage images 
resource "aws_ecr_repository" "Retail_DE_Repository" {
  name                 = "retail-de-repo"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "Retail_DE_Repository"
  }
}
