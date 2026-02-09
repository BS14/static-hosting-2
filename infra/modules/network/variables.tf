variable "cidr" {
  description = " VPC CIDR"
  default     = "10.0.0.0/16"
  type        = string
}

variable "project" {
description = "Project Name."
type = string
}

variable "env" {
description = "Project Environment"
type = string
}
