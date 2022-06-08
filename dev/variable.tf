variable "cidr" {}
variable "subnet-nat" {
  type = string
  default = "subnet-09da1a6f7e66cbe04"
#   "${module.vpc.public_subnets[0]}"
}
variable "public-all" {
    type = map(number)
    default = {
        "us-east-2a" = 1
        "us-east-2b" = 2
    }
}
variable "private-all" {
    type = map(number)
    default = {
        "us-east-2a" = 3
        "us-east-2b" = 4
    }    
}
# bastion
variable "key_name" {}
variable "bastion-ami" {}
variable "ingress-bastion" {}
variable "egress-bastion" {}
variable "type_bastion" {}
