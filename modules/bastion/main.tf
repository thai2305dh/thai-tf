resource "aws_instance" "bastion" {
    ami = var.ami //Phiên bản HĐH
    instance_type = var.type_bastion
    subnet_id = var.bastion-subnet
    associate_public_ip_address = var.check_public_ip_bastion
    # vpc_id = var.vpc-id
    vpc_security_group_ids = [aws_security_group.sgroup-bastion.id]
    key_name = var.key_name

    user_data = <<-EOF
    #!/bin/bash
          sudo rm -rf /var/lib/apt/lists/lock
          sudo apt update
    EOF
      tags = {
      Name = "Bastion"
    }
}
resource "aws_security_group" "sgroup-bastion" {
    name = "sgroup-bastion"
    vpc_id = var.vpc-id
}
resource "aws_security_group_rule" "sgroup-bastion" {
    security_group_id = aws_security_group.sgroup-bastion.id
    
    type = "ingress"
    to_port = var.ingress-bastion
    from_port = var.egress-bastion
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ssh-pirvate" {
    security_group_id = aws_security_group.sgroup-bastion.id
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}