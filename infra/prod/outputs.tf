output "oidc_role" {
value = module.oidc.oidc_arn
}

output "asg_name" {
value = module.asg.asg_name
}

output "launch_template_id" {
 value = module.launch_template.launch_template_id
}
