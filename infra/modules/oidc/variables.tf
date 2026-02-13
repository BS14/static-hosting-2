variable "github_repo" {
  description = "The GitHub repository in 'org/repo' format"
  type        = string
}

variable "launch_template_arn" {
description = "Launch Template ARN."
type = string
}

variable "asg_arn" {
description = "AutoScaling Group ARN."
type = string
}

variable "project" {
description = "Project Name."
type = string
}

variable "env" {
description="Project env."
type = string
}
