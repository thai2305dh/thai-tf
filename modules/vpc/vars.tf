variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  # default     = "10.0.0.0/16"
}

# A boolean flag to enable/disable DNS support in the VPC.  Defaults true.
variable "vpc_dns_support" {
  description = "Should DNS support be enabled for the VPC?"
  type        = bool
  # default     = true
}

# A boolean flag to enable/disable DNS hostnames in the VPC.  Defaults true.
variable "vpc_dns_hostnames" {
  description = "Should DNS hostnames support be enabled for the VPC?"
  type        = bool
  # default     = true
}

# Create the first public subnet in the VPC for external traffic.
variable "public_cidr_1" {
  description = "The CIDR block for the VPC."
  type        = string
  # default     = "10.0.1.0/24"
}
variable "public_cidr_2" {
  description = "The CIDR block for the VPC."
  type        = string
  # default     = "10.0.3.0/24"
}
variable "availability_zone" {
  description = "A list of allowed availability zones."
  type        = list(any)
  # default     = ["us-east-1a", "us-east-1c"]
}
variable "map_public_ip" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  type        = bool
  # default     = true
}

variable "private_cidr_1" {
  description = "The CIDR block for the VPC."
  type        = string
  # default     = "10.0.2.0/24"
}
variable "private_cidr_2" {
  description = "The CIDR block for the VPC."
  type        = string
  # default     = "10.0.4.0/24"
}