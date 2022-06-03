variable "ami" {
    type = string
}
variable "type_bastion" {
      type = string
}
variable "ingress-bastion" {
      type = string
}
variable "egress-bastion" {
      type = string
}
variable "vpc-id" {
    type = string
}
# variable "cidr_blocks" {
#   type = string
# }
variable "bastion-subnet" {
    type = string
}
variable "check_public_ip_bastion" {
    type = bool
}