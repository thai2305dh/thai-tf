# tạo public và private subnet - Vùng chứa đối tượng cần truy cập( Ở đây là dải IP )
// public : các service cần đi ra ngoài internet - Dùng for_each
resource "aws_subnet" "public-subnets" {
    for_each = var.public-subnet-stt
    vpc_id = aws_vpc.vpc.id
    availability_zone = each.key
    cidr_block = cidrsubnet(var.cidr-vpc, 4, each.value) 
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private-subnets" {
    for_each = var.private-subnet-stt
    vpc_id = aws_vpc.vpc.id
    availability_zone = each.key
    cidr_block = cidrsubnet(var.cidr-vpc, 4, each.value) 
    # map_public_ip_on_launch = true
}

#tạo internet gateway- Khi tạo 1 vpc thì nó là private network, muốn truy cập được từ internet cần thông qua Internet gateway
resource "aws_internet_gateway" "gw-thai" {
    vpc_id = aws_vpc.vpc.id //attach to vpc
    
    tags = {
        Name = "gw-thai"
    }
}

# tạo router table- Sau khi thông qua internet gateway, route table vẽ đường cho các lớp mạng trong dải ip
resource "aws_route_table" "art-thai" {
    vpc_id = aws_vpc.vpc.id

    route  {
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.gw-thai.id
    }

    tags = {
        "Name" = "art-thai"
    }
}
# associate route table for public subnet
resource "aws_route_table_association" "public-subnets" {
    depends_on = [aws_subnet.public-subnets]
    for_each = aws_subnet.public-subnets

    subnet_id = each.value.id
    route_table_id = aws_route_table.art-thai.id
}
