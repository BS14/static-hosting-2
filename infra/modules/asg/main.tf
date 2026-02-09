resource "aws_autoscaling_group" "this" {
  name_prefix         = "${var.project}-${var.env}-asg-"
  vpc_zone_identifier = var.private_subnet_ids # Spreads instances across AZs
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity

  # Wait for instances to pass health checks from the Load Balancer
  health_check_type         = "ELB"
  health_check_grace_period = 300 # 5 minutes to bootstrap Nginx

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  # Automated Rolling Update for Immutable Infrastructure
  instance_refresh {
    strategy = "Rolling"
    preferences {
      # Keep at least 50% of capacity online during the update
      min_healthy_percentage = 50
    }
  }

  # Prevent Terraform from reverting versions changed by GitHub Actions
  lifecycle {
    ignore_changes = [
      launch_template[0].version,
      desired_capacity
    ]
  }

  # Tag instances so you can identify them in the console
  tag {
    key                 = "Name"
    value               = "${var.project}-${var.env}-web-node"
    propagate_at_launch = true
  }
}
