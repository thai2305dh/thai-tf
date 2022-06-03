variable "ami" {
    type = string
}
variable "type" {
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
