# VPC endpoints created to allow the Subnet within the VPC to communicate with AWS ECR & S3
# This is done so that Docker images can be pulled from the ECR (backed on S3) & ran via AWS Batch service

# Security Group for the VPC endpoints
# This is required for the interface endpoints (ECR API & ECR DKR) to allow HTTPS traffic
resource "aws_security_group" "vpc_endpoints_sg" {
  vpc_id = aws_vpc.Retail_DE_VPC.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoints-sg"
  }
}

# VPC Endpoint for S3
# Endpoint created for S3 and attached to the route table of the public subnet within our VPC
# This lets VPC route traffic to S3 directly without going through public internet 
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.Retail_DE_VPC.id
  service_name      = "com.amazonaws.${var.AWS_DEFAULT_REGION}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.retail_route_public.id]

  tags = {
    Name = "s3-endpoint"
  }
}


# Two interface endpoints created below. Enables the VPC to access Amazon ECR service APIs &
# Docker registry. These endpoints are attached to the public subnet in the VPC and the security groups
# laid out above manage access etc. 

# VPC Endpoint for ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id             = aws_vpc.Retail_DE_VPC.id
  service_name       = "com.amazonaws.${var.AWS_DEFAULT_REGION}.ecr.api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.retail_public.id]
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "ecr-api-endpoint"
  }
}

# VPC Endpoint for ECR DKR
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id             = aws_vpc.Retail_DE_VPC.id
  service_name       = "com.amazonaws.${var.AWS_DEFAULT_REGION}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.retail_public.id]
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "ecr-dkr-endpoint"
  }
}

# VPC Endpoint for CloudWatch Logs
resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id            = aws_vpc.Retail_DE_VPC.id
  service_name      = "com.amazonaws.${var.AWS_DEFAULT_REGION}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.retail_public.id]
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "cloudwatch-logs-endpoint"
  }
}
