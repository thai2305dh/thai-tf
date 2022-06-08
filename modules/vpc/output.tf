output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.vpc.id
}
output "public_subnets" {
    value = [
      for subnet in aws_subnet.public-subnets : subnet.id
    ]
}
output "private_subnets" {
    value = [
        for subnet in aws_subnet.private-subnets : subnet.id
    ]
}
output "db_subnet_group" {
    value = aws_db_subnet_group.subnet-group.id
}
output "az" {
    value = [ for az in aws_subnet.public-subnets : az.availability_zone ]
}
# output "sg-nat-id" {
#   value = aws_security_group.
# }
output "vpc_cidr" {
    value = aws_vpc.vpc.cidr_block
}
output "nat-gateway" {
    value = aws_nat_gateway.nat-1a.id
}