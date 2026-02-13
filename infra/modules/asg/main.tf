resource "aws_autoscaling_group" "this" {
  name_prefix         = "${var.project}-${var.env}-asg-"
  vpc_zone_identifier = var.private_subnet_ids # Spreads instances across AZs
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity

  health_check_type         = "ELB"
  health_check_grace_period = 300

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  # Automated Rolling Update for Immutable Infrastructure
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  lifecycle {
    ignore_changes = [
      launch_template[0].version,
      desired_capacity
    ]
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-${var.env}-web-node"
    propagate_at_launch = true
  }
}
