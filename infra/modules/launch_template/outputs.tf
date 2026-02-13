output "launch_template_id" {
  value = aws_launch_template.this.id
}

output "launch_template_latest_version" {
  value = aws_launch_template.this.latest_version
}

output "launch_template_name" {
  value = aws_launch_template.this.name
}

output "launch_template_arn" {
  value = aws_launch_template.this.arn
}
