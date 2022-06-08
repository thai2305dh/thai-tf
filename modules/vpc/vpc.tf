//Tạo vpc tên, dải ip
resource "aws_vpc" "vpc" {
    cidr_block       = var.cidr-vpc
    enable_dns_support = true
    enable_dns_hostnames = var.dns-hostname // Bật tắt tên máy chủ dns
    instance_tenancy = "default"

    tags = {
      Name = "vpc-thai-project"
    }
}

#Gộp và gán route table chung cho subnet
# resource "aws_db_subnet_group" "pl-subnet-group-tf" {
#   subnet_ids = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1b.id]

#   tags = {
#     Name = "public-subnet-group-tf"
#   }
# }
# resource "aws_db_subnet_group" "pr-subnet-group-tf" {
#   subnet_ids = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id]

#   tags = {
#     Name = "private-subnet-group-tf"
#   }
# }
