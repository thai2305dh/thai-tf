# variable "tf-key" {
#     default = "tf-key.pub"
# }
# variable "terraform-ubuntu-ami" {
#     type = string
#     default = "ami-0770be1d625a007a8"
# }
variable "cidr-vpc" {
  type = string
}
variable "dns-hostname" {
  type = bool
}
variable "subnet-nat" {
  type = string
}
variable "public-subnet-stt" {
  type = map(number)
}
variable "private-subnet-stt" {
  type = map(number)
}
