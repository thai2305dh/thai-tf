variable "vpc_cidr_block" {
  type = string
}

variable "name" {
  type = string
}

variable "map_az_subnet" {
  type = map(number)
}