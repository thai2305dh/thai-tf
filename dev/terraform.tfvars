# db-instance-type = db.t2.micro
# db-name = thuvien
# username = thai
# password = thai2305

 cidr = "10.0.0.0/16"

bastion-ami = "ami-0fb653ca2d3203ac1"
type_bastion = "t2.micro"
ingress-bastion = -1
egress-bastion = -1
key_name = "beanstalk"


#Webserver-cluster
ami-webserver = "ami-0356b1cd4aa0ee970"
type-webserver = "t2.micro"
# min-webserver = 1
# max-webserver = 1
port-alb-access = 80
protocol-alb-access = "HTTP"
path-alb-healthcheck = "/menu.php"
port-alb-health = 80
protocol-alb-health = "HTTP"
action-alb-request = "forward"