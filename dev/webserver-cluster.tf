module "webserver-cluster" {
    source = "../modules/webserver-cluster"
    vpc-id = "${module.vpc.vpc_id}"
    # private-subnet = module.vpc.private_subnet
    ami-instance = var.ami-webserver
    type-instance = var.type-webserver
    key-name = "key"
    associate-public-ip = false
    # vpc-id = var.vpc_id
    min = var.min
    max = var.max
    alb-request-access-port = var.port-alb-access
    alb-request-access-protocol = var.protocol-alb-access
    alb-request-health-path = var.path-alb-healthcheck
    alb-request-health-port = var.port-alb-health
    alb-request-health-protocol = var.protocol-alb-health

    alb-internal = false

    # Enable HTTPS Listener?
    alb-listener-https = false //listening HTTP(80)
    alb-listener-protocol = var.protocol-alb-access
    alb-listener-port = var.port-alb-access
    alb-action = var.action-alb-request
    public-subnets = "${module.vpc.public_subnets[0]}"
}

resource "aws_security_group_rule" "allow-ssh" {
    security_group_id = module.webserver-cluster.sgroup_asg_id
    type = "ingress"

    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = "${module.webserver-cluster.sgroup-nat-id}" 
}
resource "aws_security_group_rule" "allow-icmp" { //cho phép ping đến
    security_group_id = module.webserver-cluster.sgroup_asg_id
    type = "ingress"

    from_port = -1
    to_port = -1
    protocol = "icmp"
    source_security_group_id = "${module.vpc.vpc_cidr}" 
}
resource "aws_security_group_rule" "allow-nat" {
    security_group_id = module.webserver-cluster.sgroup_asg_id

    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    source_security_group_id = module.vpc.nat-gateway
}