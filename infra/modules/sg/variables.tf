variable "sg_name" {
  type        = string
  description = "Name of a security group."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "ingress_rules" {
  description = "Ingress Rules"
  default     = []
}

variable "egress_rules" {
  description = "Egress Rules"
  default     = []
}
