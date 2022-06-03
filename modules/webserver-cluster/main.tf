locals {
  sg_alb_rules = {
    "rule_http" = ["ingress", 80, 80, "tcp", ["0.0.0.0/0"]] // Cho phép lưu lượng truy cập HTTP từ bất kỳ Client nào vào
    "rule_https" = ["ingress", 443, 443, "tcp", ["0.0.0.0/0"]] // Cho phép lưu lượng truy cập HTTPS từ bất kỳ Client nào vào
    "rule_out" = ["egress", 0, 0, "-1", ["0.0.0.0/0"]] // Cho phép mọi mọi request ra ngoài Internet
  }
  sg_asc_rules = {
    "rule_http_alb" = ["ingress", 80, 80, "tcp", "${aws_security_group.sg-alb.id}"] // Cho phép check healthy HTTP từ alb
    "rule_https_alb" = ["ingress", 443, 443, "tcp", "${aws_security_group.sg-alb.id}"] // Cho phép check healthy HTTPS từ alb
    # "rule_ssh_nat" = ["ingress", 22, 22, "ssh", "${aws_security_group.sg-ssh.id}"] // Cho phép truy cập ssh từ bastion
  }
}
resource "aws_security_group" "sg-alb" {
  name = "sg-alb"
  vpc_id = var.vpc-id
}

resource "aws_security_group_rule" "sg-rule-alb" {
  security_group_id = aws_security_group.sg-alb.id
  
  for_each = local.sg_alb_rules

  type = each.value[0]
  to_port = each.value[1]
  from_port = each.value[2]
  protocol = each.value[3]
  cidr_blocks = each.value[4]
}
resource "aws_security_group" "sg-asc" {
    name = "sg-asc"
    vpc_id = var.vpc-id
}
resource "aws_security_group_rule" "sg-rule-asc" {
    security_group_id = aws_security_group.sg-asc.id
    for_each = local.sg_asc_rules

    type = each.value[0]
    to_port = each.value[1]
    from_port = each.value[2]
    protocol = each.value[3]
    source_security_group_id = each.value[4]
}
resource "aws_security_group" "sg-nat-id" {
    name = "sg-nat-id"
    vpc_id = var.vpc-id
}
resource "aws_security_group_rule" "sg-nat-id" {
    security_group_id = aws_security_group.sg-nat-id.id

    type = "ingress"
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
# Cho phép giao tiếp giữa các hosts trong vpc
resource "aws_security_group_rule" "sg-rule-asg-ingress" {
  security_group_id = aws_security_group.sg-asc.id
  type = "ingress"

  from_port = 0
  to_port = 65535
  protocol = "tcp"
  source_security_group_id = aws_security_group.sg-asc.id
}

resource "aws_launch_configuration" "webserver-cluster" {
  name = "terraform-webserver-cluster"

  image_id = var.ami-instance
  instance_type = var.type-instance
  key_name = var.key-name
  # user_data = var.user-data
  security_groups = [ "${aws_security_group.sg-asc.id}" ]

  associate_public_ip_address = var.associate-public-ip

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "webserver-cluster" {
  name = "terraform-webserver-cluster"

#   vpc_zone_identifier = [ "${var.private-subnets}" ]

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

# ALB -----------------------------------------------------------------

resource "aws_alb_target_group" "alb" {
  name = "terraform-target"
  vpc_id = var.vpc-id

  target_type = "instance"
  port = var.alb-request-access-port
  protocol = var.alb-request-access-protocol

  health_check {
    path = var.alb-request-health-path
    protocol = var.alb-request-health-protocol
    port = var.alb-request-health-port
  }

  depends_on = [ aws_autoscaling_group.webserver-cluster ]
}

resource "aws_autoscaling_attachment" "attach" {
  alb_target_group_arn = aws_alb_target_group.alb.arn
  autoscaling_group_name = aws_autoscaling_group.webserver-cluster.id
}

resource "aws_alb" "alb" {
  name = "terraform-alb"

  internal = var.alb-internal
  security_groups = [ "${aws_security_group.sg-alb.id}" ]
  subnets = [ "${var.public-subnets}" ]

  ip_address_type = "ipv4"
  load_balancer_type = "application"
  idle_timeout = 60
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  enable_http2 = false

  depends_on = [ aws_autoscaling_group.webserver-cluster ]

  tags = {
    Name = "terraform-alb"
  }
}

resource "aws_alb_listener" "alb-listener-http" {
  count = var.alb-listener-https ? 0 : 1

  load_balancer_arn = aws_alb.alb.arn

  port = var.alb-request-access-port
  protocol = var.alb-request-access-protocol

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb.arn
  }
}

resource "aws_alb_listener" "alb-listener-https" {
  count = var.alb-listener-https ? 1 : 0

  load_balancer_arn = aws_alb.alb.arn

  port = var.alb-listener-port
  protocol = var.alb-listener-protocol
  ssl_policy = ""
  certificate_arn = ""

  default_action {
    type = var.alb-action
    target_group_arn = aws_alb_target_group.alb.arn
  }
}


