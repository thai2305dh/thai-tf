variable "cidr" {
    type = string
    default = "10.0.0.0/16"
}
variable "subnet-nat" {
  type = string
  default = "subnet-09da1a6f7e66cbe04"
}
variable "public" {
    type = map(number)
    default = {
        "us-east-2a" = 1
        "us-east-2b" = 2
    }
}
variable "private" {
    type = map(number)
    default = {
        "us-east-2a" = 3
        "us-east-2b" = 4
    }    
}
