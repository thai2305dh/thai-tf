terraform {
  backend "s3" {
    region = "us-east-2" // Báo lỗi  incorrect region, the bucket is not in 'us-east-2' region at endpoint ''
    bucket = "mybucket"
    key    = "terraform.tfstate"
    encrypt        = false
  }
}

provider "aws" {
    region = "us-east-2"
    access_key = "*********"
    secret_key = "***********"
}

resource "aws_instance" "ubuntu-tf" {
    ami         = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private.id
    key_name = data.aws_key_pair.thaikey.id
    user_data     = <<-EOF
                  #!/bin/bash 
                  sudo su
                  yum -y update
                  amazon-linux-extras install nginx1.12-y
                  systemctl start nginx.service
                  systemctl enable nginx.service
				          amazon-linux-extras install php7.3
				          yum install php-xml php-mbstring
				          service php-fpm start
				          service nginx restart
				  
                  EOF 
#     network_interface {
#     network_interface_id = aws_network_interface.ubuntu.id
#     device_index         = 0
#   }

#     credit_specification {
#     cpu_credits = "unlimited"
#   }
}
resource "aws_s3_bucket" "s3-terraform" {
    bucket = "tf-state-thai"
    lifecycle {
        prevent_destroy = true
    }
    versioning {
        enabled = true
    }
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}
