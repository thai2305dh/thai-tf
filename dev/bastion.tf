variable "bastion-ami" {
    type = string
    default = "ami-0fb653ca2d3203ac1"
}
variable "ingress" {
    type = string
    default =  -1
}
variable "egress" {
    type = string
    default =  -1
}
variable "type" {
    type = string
    default = "t2.micro"
}
# variable "cidr-bastion" {
#   type = string
# }
module "bastion" {
    source = "../modules/bastion"
    ami = var.bastion-ami //Phiên bản HĐH
    vpc-id = "${module.vpc.vpc_id}"
    type = var.type
    # cidr_blocks = var.cidr-bastion
    bastion-subnet = "${module.vpc.public_subnets[0]}"
    # associate_public_ip_address = true
    ingress-bastion = var.ingress
    egress-bastion = var.egress
}