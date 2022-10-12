variable "tf-key"{

    default = "tf-key.pub"
}
variable "terraform-ubuntu-ami" {
    type = string
    default = "ami-0770be1d625a007a8"
}
variable "vpc_cidr" {
  type  = string
}