variable "user-data" {}

variable "key_name" {
    type = string
}
variable "ami-subnet" {
    type = string
}
variable "ingress-ami" {
    type = string
}
variable "egress-ami" {
    type = string
}
variable "vpc-id" {
    type = string
}   