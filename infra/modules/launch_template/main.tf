data "aws_ami" "ubuntu_24" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project}-${var.env}-web-"
  image_id      = data.aws_ami.ubuntu_24.id
  instance_type = var.instance_type
  ebs_optimized = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # IMDSv2
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  # Dynamic Block for Storage
  dynamic "block_device_mappings" {
    for_each = var.extra_disks
    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        volume_size           = block_device_mappings.value.size
        volume_type           = "gp3"
        delete_on_termination = true
        encrypted             = true
      }
    }
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.sg_id]
  }

  user_data = base64encode(templatefile("${path.module}/scripts/install_nginx.tftpl", {
    index_html = var.index_html_content
  }))

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      user_data
    ]
  }
}
