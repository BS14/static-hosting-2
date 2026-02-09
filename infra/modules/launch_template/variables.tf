variable "instance_type" {
  type    = string
  default = "t3.nano"
}

variable "extra_disks" {
  description = "List of extra disks to attach"
  type = list(object({
    device_name = string
    size        = number
  }))
  default = [
    {
      device_name = "/dev/sdf"
      size        = 20
    }
  ]
}

variable "project" {
  description = "Project Name."
  type        = string
}

variable "env" {
  description = "Project Environment"
  type        = string
}

variable "index_html_content" {
  description = "The actual HTML code to be placed in index.html"
  type        = string
}

variable "sg_id" {
  type        = string
  description = "Web security group to be attached to instance."
}
