//Tạo vpc tên, dải ip
resource "aws_vpc" "vpc-thai" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true // Bật tắt tên máy chủ dns
  instance_tenancy = "default"

  tags = {
    Name = "vpc-thai"
  }
}
# tạo public và private subnet - Vùng chứa đối tượng cần truy cập( Ở đây là dải IP )
// public : các service cần đi ra ngoài internet
resource "aws_subnet" "public-subnet-1a" {
    vpc_id = aws_vpc.vpc-thai.id
    cidr_block       = "10.0.0.0/24"
    tags = {
        Name = "Public Subnet 1a"
    }
    availability_zone = "us-east-2a"
    map_public_ip_on_launch = true //Chỉ định true để chỉ ra rằng instances được đưa vào subnet phải được gán một địa chỉ IP công cộng
}
resource "aws_subnet" "public-subnet-1b" {
    vpc_id = aws_vpc.vpc-thai.id
    cidr_block       = "10.0.2.0/24"
    tags = {
        Name = "Public Subnet 1b"
    }
    availability_zone = "us-east-2b"
    map_public_ip_on_launch = true
}
# resource "aws_subnet" "public-subnet-1c" {
#     vpc_id = aws_vpc.vpc-thai.id
#     cidr_block       = "10.0.0.0/24"
#     tags = {
#         Name = "Public Subnet"
#     }
#     availability_zone = "us-east-2a"
# }
// private : các service k cần đi ra ngoài internet
resource "aws_subnet" "private-subnet-1a" {
    vpc_id = aws_vpc.vpc-thai.id

    cidr_block       = "10.0.1.0/24"
    tags = {
        Name = "Private Subnet 1a"
    }
    availability_zone = "us-east-2a"
    map_public_ip_on_launch = true
}
resource "aws_subnet" "private-subnet-1b" {
    vpc_id = aws_vpc.vpc-thai.id

    cidr_block       = "10.0.3.0/24"
    tags = {
        Name = "Private Subnet 1b"
    }
    availability_zone = "us-east-2b"
    map_public_ip_on_launch = true
}
#tạo internet gateway- Khi tạo 1 vpc thì nó là private network, muốn truy cập được từ internet cần thông qua Internet gateway
resource "aws_internet_gateway" "gw-thai" {
    vpc_id = aws_vpc.vpc-thai.id //attach to vpc
    tags = {
        Name = "gw-thai"
    }
}

# tạo router table- Sau khi thông qua internet gateway, route table vẽ đường cho các lớp mạng trong dải ip
resource "aws_route_table" "art-thai" {
  vpc_id = aws_vpc.vpc-thai.id
  route  {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.gw-thai.id
    
  }
  tags = {
    "Name" = "art-thai"
  }
}
# associate route for public subnet
resource "aws_route_table_association" "public-subnet-1a" { // Gán route table cho public subnet 1a
  subnet_id = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.art-thai.id
}
resource "aws_route_table_association" "public-subnet-1b" { // Gán route table cho public subnet 1a
  subnet_id = aws_subnet.public-subnet-1b.id
  route_table_id = aws_route_table.art-thai.id
}
# elastic ip for nat gateway

resource "aws_eip" "nat_eip-1" {
    vpc = true
    depends_on = [aws_internet_gateway.gw-thai]
    tags = {
        Name = "NAT Gateway EIP 1"
    }
}
resource "aws_eip" "nat_eip-2" {
    vpc = true
    depends_on = [aws_internet_gateway.gw-thai]
    tags = {
        Name = "NAT Gateway EIP 2"
    }
}
# Main Nat Gateway for vpc
resource "aws_nat_gateway" "nat-1a" {
    allocation_id = aws_eip.nat_eip-1.id
    subnet_id = aws_subnet.public-subnet-1a.id
    tags = {
        Name = "Main NAT Gateway"
    }
}
resource "aws_nat_gateway" "nat-1b" {
    allocation_id = aws_eip.nat_eip-2.id
    subnet_id = aws_subnet.public-subnet-1b.id
    tags = {
        Name = "Client NAT Gateway"
    }
}
# resource "aws_nat_gateway" "nat-1c" {
#     allocation_id = aws_eip.nat_eip.id
#     subnet_id = aws_subnet.public-subnet-1a.id
#     tags = {
#         Name = "Main NAT Gateway"
#     }
# }

#Gộp và gán route table chung cho private 
resource "aws_db_subnet_group" "pr-subnet-group-tf" {
  subnet_ids = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-1b.id]

  tags = {
    Name = "private-subnet-group-tf"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc-thai.id
    route  {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_nat_gateway.nat-1a.id
    
  }
  tags = {
    Name = "terraform-route-table-private-subnet"
  }
}
resource "aws_route_table_association" "private-subnet-1a" { // Gán route table cho private subnet 1a
  subnet_id = aws_subnet.private-subnet-1a.id
  route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "private-subnet-1b" { // Gán route table cho private subnet 1b
  subnet_id = aws_subnet.private-subnet-1b.id
  route_table_id = aws_route_table.private-rt.id
}