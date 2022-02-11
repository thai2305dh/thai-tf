//Tạo vpc tên, dải ip
resource "aws_vpc" "vpc-thai" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-thai"
  }
}
# tạo public và private subnet - Vùng chứa đối tượng cần truy cập( Ở đây là dải IP )
// public : các service cần đi ra ngoài internet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vpc-thai.id

    cidr_block       = "10.0.0.0/24"
    tags = {
        Name = "Public Subnet"
    }
    availability_zone = "us-east-2a"
}
// private : các service k cần đi ra ngoài internet
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.vpc-thai.id

    cidr_block       = "10.0.1.0/24"
    tags = {
        Name = "Private Subnet"
    }
    availability_zone = "us-east-2a"
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

# elastic ip for nat gateway

resource "aws_eip" "nat_eip" {
    vpc = true
    depends_on = [aws_internet_gateway.gw-thai]
    tags = {
        Name = "NAT Gateway EIP"
    }
}

# Main Nat Gateway for vpc
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public.id
    tags = {
        Name = "Main NAT Gateway"
    }
}

# associate route for public subnet

resource "aws_route_table_association" "public-subnet" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.art-thai.id
}
#Tao 1 secuirty group cho phep ket noi tu myIP - 1 lớp bảo mật giúp lọc các nhóm có quyền truy cập
resource "aws_security_group" "Sg" {
  name = "Sg"
  vpc_id = aws_vpc.vpc-thai.id
  
  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.83/32"] 
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Sg"
  }
  
}
// Security Group cho phep ket noi duy nhat tu sg
resource "aws_security_group" "Sg-private" {
  name = "Sg-private"
  vpc_id = aws_vpc.vpc-thai.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Sg-private"
  }
}

// Network acls 
# resource "aws_network_acl" "main" {
#   vpc_id = aws_vpc.vpc-thai.id

#   egress {
#     protocol   = "tcp"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "10.3.0.0/18"
#     from_port  = 443
#     to_port    = 443
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "10.3.0.0/18"
#     from_port  = 80
#     to_port    = 80
#   }

#   tags = {
#     Name = "main"
#   }
# }