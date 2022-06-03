variable "vpc-id" {
    type = string
}
variable "ami-instance" {
    type = string
}
variable "type-instance" {
    type = string
}
variable "key-name" {
    type = string
}
# variable "user-data" {
#     type = string
# }
variable "associate-public-ip" {
    type = bool
}
variable "min" {
    type = number
}
variable "max" {
    type = number
}
variable "alb-request-access-port" {
  type = number
}
variable "alb-request-access-protocol" {
  type = string
}

variable "alb-request-health-protocol" {
  type = string
}

variable "alb-request-health-port" {
  type = number
}

variable "alb-request-health-path" {
  type = string
}

variable "alb-internal" {
  type = bool
}

variable "alb-listener-https" {
  description = "if false, alb will listening HTTP(80)"
  type = bool
}

variable "alb-listener-protocol" {
  type = string
}

variable "alb-listener-port" {
  type = number
}

variable "alb-action" {
  type = string
}
variable "public-subnets" {
  type = string
}