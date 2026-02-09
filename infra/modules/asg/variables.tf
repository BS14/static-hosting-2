variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}


variable "target_group_arn" {
  type = string
}

variable "launch_template_id" {
  type = string
}

variable "launch_template_version" {
  type = string
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "desired_capacity" {
  type    = number
  default = 1
}
