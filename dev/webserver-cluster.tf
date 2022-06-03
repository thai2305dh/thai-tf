// File cấu hình cho webserver
# data "template_file" "provision" {
#     template = file("${path.module}/file/provision.sh")
# }
variable "type-webserver" {
    type = string
    default = "t2.micro"
}
variable "min" {
    type = number
    default = 2
}
variable "max" {
    type = number
    default = 3
}
variable "ami-webserver" {
    type = string
    default = "ami-0fb653ca2d3203ac1"
}
variable "port-alb-access-port" {}
variable "protocol-alb-access-protocol" {}

variable "path-alb-healthcheck-path" {}
variable "port-alb-health-port" {}
variable "protocol-alb-health-protocol" {}
variable "action-alb-request" {}
module "webserver-cluster" {
    source = "../modules/webserver-cluster"
    # env = var.env
    vpc-id = "${module.vpc.vpc_id}"
    # private-subnet = module.vpc.private_subnet

    ami-instance = var.ami-webserver
    type-instance = var.type-webserver
    key-name = "key"
    # user-data = "${data.template_file.provision.rendered}"
    # user-data = <<-EOF
    # #!/bin/bash
    #               sudo rm -rf /var/lib/apt/lists/lock
    #               sudo apt update
    # EOF
    associate-public-ip = false

    min = var.min
    max = var.max
    alb-request-access-port = var.port-alb-access-port
    alb-request-access-protocol = var.protocol-alb-access-protocol
    alb-request-health-path = var.path-alb-healthcheck-path
    alb-request-health-port = var.port-alb-health-port
    alb-request-health-protocol = var.protocol-alb-health-protocol

    alb-internal = false

    # Enable HTTPS Listener?
    alb-listener-https = false //listening HTTP(80)
    alb-listener-protocol = var.protocol-alb-access
    alb-listener-port = var.port-alb-access
    alb-action = var.action-alb-request
    public-subnets = "${module.vpc.public_subnets[0]}"
}

resource "aws_security_group_rule" "allow-ssh" {
    security_group_id = module.webserver-cluster.sg_asg_id
    type = "ingress"

    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = "${module.webserver-cluster.sg-nat-id}" 
}
resource "aws_security_group_rule" "allow-icmp" { //cho phép ping đến
    security_group_id = module.webserver-cluster.sg_asg_id
    type = "ingress"

    from_port = -1
    to_port = -1
    protocol = "icmp"
    source_security_group_id = "${module.vpc.vpc_cidr}" 
}
resource "aws_security_group_rule" "allow-nat" {
    security_group_id = module.webserver-cluster.sg_asg_id

    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    source_security_group_id = module.vpc.nat-gateway
}