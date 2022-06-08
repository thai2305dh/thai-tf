# elastic ip for nat gateway
resource "aws_eip" "nat_eip-1" {
    vpc = true
    depends_on = [aws_internet_gateway.gw-thai]

    tags = {
        Name = "NAT Gateway EIP 1"
    }
}

# Main Nat Gateway for vpc
resource "aws_nat_gateway" "nat-1a" {
    allocation_id = aws_eip.nat_eip-1.id
    subnet_id = values(aws_subnet.public-subnets)[1].id

    tags = {
        Name = "Main NAT Gateway"
    }
}

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.vpc.id

    route  {
    cidr_block = "0.0.0.0/0" 
    gateway_id =  aws_nat_gateway.nat-1a.id 
    }
  
    tags = {
        Name = "terraform-route-table-private-subnet"
    }
}

resource "aws_route_table_association" "private-subnets" {
    depends_on = [aws_subnet.private-subnets]
    for_each = aws_subnet.private-subnets

    subnet_id = each.value.id
    route_table_id = aws_route_table.private-rt.id
}
# Đảm bảo tính sẵn sàng cao thì dùng thêm nat
# resource "aws_eip" "nat_eip-2" {
#     vpc = true
#     depends_on = [aws_internet_gateway.gw-thai]
#     tags = {
#         Name = "NAT Gateway EIP 2"
#     }
# }
# resource "aws_nat_gateway" "nat-1b" {
#     allocation_id = aws_eip.nat_eip-2.id
#     subnet_id = aws_subnet.public-subnet-1b.id
#     tags = {
#         Name = "Client NAT Gateway"
#     }
# }