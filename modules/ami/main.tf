resource "aws_instance" "webserver" {

    ami = "ami-03afa323b8fcb1470" //Phiên bản HĐH
    instance_type = "t2.micro"
    subnet_id = var.ami-subnet
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.sgroup-ami.id]
    key_name = var.key_name
    user_data = var.user-data

    tags = {
    Name = "AMI-server"
  }
}
resource "aws_ami_from_instance" "ami-server" {
    name               = "ami-server"
    source_instance_id = "${aws_instance.webserver.id}"
}
resource "aws_security_group" "sgroup-ami" {
    name = "sgroup-ami"
    vpc_id = var.vpc-id
}
resource "aws_security_group_rule" "inbound-ami" {
    security_group_id = aws_security_group.sgroup-ami.id
    
    type = "ingress"
    to_port = var.ingress-ami
    from_port = var.egress-ami
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "outbound-ami" {
    security_group_id = aws_security_group.sgroup-ami.id
    
    type = "egress"
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}