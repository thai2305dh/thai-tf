resource "aws_instance" "bastion" {
    ami = var.ami //Phiên bản HĐH
    instance_type = var.type
    subnet_id = var.bastion-subnet
    associate_public_ip_address = true
    # vpc_id = var.vpc-id
    vpc_security_group_ids = [aws_security_group.sg-bastion.id]
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
resource "aws_security_group" "sg-bastion" {
    name = "sg-bastion"
    vpc_id = var.vpc-id
}
resource "aws_security_group_rule" "sg-bastion" {
  security_group_id = aws_security_group.sg-bastion.id
  
  type = "ingress"
  to_port = var.ingress-bastion
  from_port = var.egress-bastion
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}