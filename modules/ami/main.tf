resource "aws_ami_from_instance" "ami-server" {
  name               = "ami-server"
  source_instance_id = "${aws_instance.webserver.id}"
}
resource "aws_instance" "webserver" {

    ami = "ami-0fb653ca2d3203ac1" //Phiên bản HĐH
    instance_type = "t2.micro"
    # subnet_id = aws_subnet.public-subnet-1a.id
    associate_public_ip_address = true
    # vpc_security_group_ids = [aws_security_group.tf-sg.id]
    key_name = var.key_name

    user_data = var.user-data
    tags = {
    Name = "AMI-server"
  }
}
