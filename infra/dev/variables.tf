variable "env" {
  type        = string
  description = "Environment for application deployment."
  default     = "dev"
}

variable "project" {
type = string
description = "Project Name"
default = "fivexl"
}

variable "cidr" {
type = string
description = "CIDR Block"
default = "10.0.0.0/16"
}
