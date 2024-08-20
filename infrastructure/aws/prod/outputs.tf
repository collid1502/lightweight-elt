// Can collect outputs, such as the IDs of created resources etc. 
output "vpc_id" {
  value = aws_vpc.Retail_DE_VPC.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.Retail_DE_Repository.repository_url
}

