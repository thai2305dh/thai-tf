# resource "aws_key_pair" "aws-key" {
#   key_name   = "aws-key"
#   public_key = file(var.PUBLIC_KEY_PATH)
# }


# resource "aws_instance" "nginx_server" {
#   ami = "${lookup(var.AMI, var.AWS_REGION)}"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "nginx_server"
#   }
#   # VPC
#   subnet_id = aws_subnet.namtnp-subnet-public-1.id
#   # Security Group
#   vpc_security_group_ids = ["${aws_security_group.sg-webserver.id}"]
#   # the Public SSH key
#   key_name = aws_key_pair.aws-key.id
#   # nginx installation
#   # storing the nginx.sh file in the EC2 instnace
#   provisioner "file" {
#     source      = "nginx.sh"
#     destination = "/tmp/nginx.sh"
#   }
#   # Exicuting the nginx.sh file
#   # Terraform does not reccomend this method becuase Terraform state file cannot track what the scrip is provissioning
#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/nginx.sh",
#       "sudo /tmp/nginx.sh"
#     ]
#   }
#   # Setting up the ssh connection to install the nginx server
#   connection {
#     type        = "ssh"
#     host        = self.public_ip
#     user        = var.EC2_USER
#     private_key = file("${var.PRIVATE_KEY_PATH}")
#   }
# }