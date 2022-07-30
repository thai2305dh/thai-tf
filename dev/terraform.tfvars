# database
db-engine = "mysql"
db-engine-version = "8.0"
db-instance-type = "db.t2.micro"
db-name = "vegefood"
username = "vegefood"
password = "Thai2305"
port = 3306

#VPC
cidr = "10.0.0.0/16"
public-all = {
    "us-east-1a" = 1
    "us-east-1b" = 2
    "us-east-1c" = 3
}
private-all = {
    "us-east-1a" = 4
    "us-east-1b" = 5
    "us-east-1c" = 6
}  

#  Bastion
bastion-ami = "ami-055e091b43e74583a"
type_bastion = "t2.micro"
ingress-bastion = 0
egress-bastion = 0
# key_name = "beanstalk"

#  Webserver-cluster
ami-webserver = "ami-0356b1cd4aa0ee970"
type-webserver = "t2.micro"
min =2
max = 4

key-bastion = "beanstalk"
#  Webserver-cluster-alb
port-alb-access = 80
protocol-alb-access = "HTTP"
path-alb-healthcheck = "/"
port-alb-health = 80
protocol-alb-health = "HTTP"
action-alb-request = "forward"

#ami
ingress-ami = 0
egress-ami = 0
# Code deploy
# deployment-config-name = "CodeDeployDefault.OneAtATime"