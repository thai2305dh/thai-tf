resource "aws_autoscaling_group" "webserver-cluster" {
    name = "terraform-webserver-cluster"
    vpc_zone_identifier = [ "${var.asg-subnets}" ]
    min_size = var.min
    max_size = var.max
    launch_configuration = aws_launch_configuration.webserver-cluster.id
    force_delete = true
    
    lifecycle {
      create_before_destroy = true
    }

    tag {
      key = "Name"
      value = "terraform-webserver-cluster"
      propagate_at_launch = true
    }

  /*dynamic "tag" {
    for_each = var.custom-tags
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }*/
}


