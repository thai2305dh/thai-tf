#Tạo EC2 trong public subnet làm Bastion
resource "aws_instance" "tf-ec2" {
    ami = "ami-0fb653ca2d3203ac1" //Phiên bản HĐH
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public-subnet-1a.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.tf-sg.id]
    key_name = "key"

    user_data = <<-EOF
    #!/bin/bash
                  sudo rm -rf /var/lib/apt/lists/lock
                  sudo apt update
  EOF
    tags = {
    Name = "Bastion"
  }
}
# resource "aws_instance" "tf-ec2-2" {
#     ami = "ami-0fb653ca2d3203ac1" //Phiên bản HĐH
#     instance_type = "t2.micro"
#     subnet_id = aws_subnet.private-subnet-1b.id
#     associate_public_ip_address = true
#     vpc_security_group_ids = [aws_security_group.tf-sg.id]
#     key_name = "key"

#     user_data     = <<-EOF
#                   #!/bin/bash 
#                    sudo su
#                   apt-get update
#                   apt-get install nginx1.12-y
#                   systemctl start nginx.service
#                   systemctl enable nginx.service
# 				          apt0get install php7.4
# 				          apt install php-xml php-mbstring
# 				          service php-fpm start
# 				          service nginx restart
				  
#                   EOF 
# }
# Security Group cho bastion
resource "aws_security_group" "tf-sg" {
    name = "tf-sg"
    vpc_id = aws_vpc.vpc-thai.id
    ingress {
        description = "allow http from ELB"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "allow all outbound connect"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
      tags = {
    Name = "sg-for-owner"
  }
}
# # resource "tls_private_key" "tf-prk" {
# #   algorithm = "RSA"
# #   rsa_bits  = 4096
# # }
# resource "aws_key_pair" "key" {
#   key_name = "key"
# #I will change public_key here
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQKz8f3XrQCdrjMSuYCCEpfyggnYXCt4ua3ZJszUw7v52b9hcbtJMmxdMtiIebDulNSJCKIoYw50yiIcRMAY2vj8kHtPG8rRlaImTJf2jo726A4N+0StD0sLZAuWgZ7A2ezbVgh0OccWESYmPid+IWR/v75u04rfPOlR4WzsYTtPPxMuJ2+5gxzXZ1F49qMGuxc2XKuxl9fiK+CXGQ1NtFMK7WTTtrdgSMQ1AnfAM57IXWmMHzELU0RNZpTwnj7qKzW1erpmxXwwU8IqjWUSSvPUl0vTw5tsm47hVKD9FuwUCsaPYgPcaYbUilxfRstAqXNvVoHRse4iZfQXB2/G1X yeu@kali"
# }

# Security group cho instance
resource "aws_security_group" "tf-sg-private" {
    name = "tf-sg-private-subnet"
    vpc_id = aws_vpc.vpc-thai.id

    ingress {
        description = "allow SSH from bastion"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${aws_instance.tf-ec2.private_ip}/32"] // IP public của bastion
    }
    egress {
        description = "allow all outbound connect"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
      tags = {
    Name = "sg-for-private-subnet"
  }
}
