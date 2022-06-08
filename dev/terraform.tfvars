# database
db-engine = "mysql"
db-engine-version = "8.0"
db-instance-type = "db.t2.micro"
db-name = "thuvien"
username = "thai"
password = "Thai2305@"
port = 3306

#VPC
cidr = "10.0.0.0/16"
public-all = {
    "us-east-2a" = 1
    "us-east-2b" = 2
}
private-all = {
    "us-east-2a" = 3
    "us-east-2b" = 4
}  

#  Bastion
bastion-ami = "ami-0fb653ca2d3203ac1"
type_bastion = "t2.micro"
ingress-bastion = -1
egress-bastion = -1
key_name = "beanstalk"

#  Webserver-cluster
ami-webserver = "ami-0356b1cd4aa0ee970"
type-webserver = "t2.micro"
min =2
max = 4
#  Webserver-cluster-alb
port-alb-access = 80
protocol-alb-access = "HTTP"
path-alb-healthcheck = "/menu.php"
port-alb-health = 80
protocol-alb-health = "HTTP"
action-alb-request = "forward"

# Code deploy
deployment-config-name = "CodeDeployDefault.OneAtATime"