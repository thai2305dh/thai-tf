# database
variable "db-engine" {}
variable "db-engine-version" { }
variable "db-instance-type" {}
variable "db-name" {}
variable "username" {}
variable "password" {}
variable "port" {}

#VPC
variable "cidr" {}
variable "public-all" {}
variable "private-all" {}

# bastion
variable "key_name" {}
variable "bastion-ami" {}
variable "ingress-bastion" {}
variable "egress-bastion" {}
variable "type_bastion" {}

#Codedeploy
# variable "deployment-config-name" {}

#Webserver
variable "type-webserver" {}
variable "ami-webserver" {}
variable "min" {}
variable "max" {}

variable "port-alb-access" {}
variable "protocol-alb-access" {}
variable "path-alb-healthcheck" {}
variable "port-alb-health" {}
variable "protocol-alb-health" {}
variable "action-alb-request" {}

#ami
variable "ingress-ami" {}
variable "egress-ami" {}
# variable "key_name_ami" {}
#key_pair
variable "key_pair_name" {
    type = string
    default = "my-key"
}