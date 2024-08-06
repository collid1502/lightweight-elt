# create a VPC (Virtual Private Cloud) which is your own virtual Private Network
# resource "aws_vpc" "Retail_DE_VPC" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags = {
#     Name = "Retail_DE_VPC"
#   }
# }
# here, we are asking terraform to set up an AWS VPC resource called "Retail_DE_VPC"
# The CIDR Block is used to configure the network 
# NOTE - higher the value that comes after the `/` the smaller the network will be 
# the tag makes the VPC easily identifiable 