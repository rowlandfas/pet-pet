variable "domain" {
  
description = "The domain name for our pet adoption project"
  type        = string
  default     = "set30.space"
}
variable "region" {
    default = "eu-west-1"
}

variable "email" {
  default = "ima@gmail.com"
}
variable "kms_key" {}