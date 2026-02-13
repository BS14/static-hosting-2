variable "project" {
  description = "Project name for resource naming and tagging"
  type        = string
}

variable "env" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs to attach to the ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The security group ID for the ALB"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate for HTTPS"
  type        = string
}

variable "domain_name" {
  description = "The specific host header to check (e.g., app.example.com)"
  type        = string
}
