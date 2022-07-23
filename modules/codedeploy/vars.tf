# variable "deployment-config-name" {
#     type = string
# }
# variable "codedeploy-asc-gr" {
#     type = list(string)
# }
variable "codedeploy-asc-gr" {
  description = "Autoscaling group to associate the deployment group with. ASG id required."
  type        = string
}


variable "lifecycle_rule_enabled" {
  description = "Enable / disable default lifecycle rule on s3 bucket."
  type        = bool
  default     = "true"
}

variable "deployment_config_name" {
  description = "Deployment config name."
  type        = string
  default     = "CodeDeployDefault.AllAtOnce"
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}

variable "expiration" {
  description = "Specifies number of days after which s3 objects will expire"
  type        = number
  default     = 120
}

variable "data_bucket_name" {
  type        = string
  description = "Name for the s3 data bucket"
}