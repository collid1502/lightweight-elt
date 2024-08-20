// Create security group for VPC
resource "aws_security_group" "retail_batch_sg" {
  name        = "retail-batch-security-group"
  description = "Security group for AWS Batch"
  vpc_id      = aws_vpc.Retail_DE_VPC.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
// Ingress and Egress Rules: The rules here allow all inbound and outbound traffic. 
// You should modify these rules based on your security requirements

// This outputs the security group ID after creation, which you can use in your Batch compute environment setup
output "security_group_id" {
  value = aws_security_group.retail_batch_sg.id
}
