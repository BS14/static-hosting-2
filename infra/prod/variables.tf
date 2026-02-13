variable "env" {
  type        = string
  description = "Environment for application deployment."
  default     = "prod"
}

variable "project" {
  type        = string
  description = "Project Name"
  default     = "fivexl"
}

variable "cidr" {
  type        = string
  description = "CIDR Block"
  default     = "192.168.0.0/16"
}
