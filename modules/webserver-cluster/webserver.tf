locals {
  sg_alb_rules = {
    "rule_http" = ["ingress", 80, 80, "tcp", ["0.0.0.0/0"]] // Cho phép lưu lượng truy cập HTTP từ bất kỳ Client nào vào
    "rule_https" = ["ingress", 443, 443, "tcp", ["0.0.0.0/0"]] // Cho phép lưu lượng truy cập HTTPS từ bất kỳ Client nào vào
    "rule_out" = ["egress", 0, 0, "-1", ["0.0.0.0/0"]] // Cho phép mọi mọi request ra ngoài Internet
  }
  sg_asc_rules = {
    "rule_http_alb" = ["ingress", 80, 80, "tcp", "${aws_security_group.sgroup-alb.id}"] // Cho phép check healthy HTTP từ alb
    "rule_https_alb" = ["ingress", 443, 443, "tcp", "${aws_security_group.sgroup-alb.id}"] // Cho phép check healthy HTTPS từ alb
    # "rule_ssh_nat" = ["ingress", 22, 22, "ssh", "${aws_security_group.sg-ssh.id}"] // Cho phép truy cập ssh từ bastion
  }
}
resource "aws_security_group" "sgroup-alb" {
    name = "sgroup-alb"
    vpc_id = var.vpc-id
}
resource "aws_iam_instance_profile" "role_profile" {
  name = "role_profile"
  role = "codedeploy-test"
}
resource "aws_security_group_rule" "sg-rule-alb" {
    security_group_id = aws_security_group.sgroup-alb.id
    
    for_each = local.sg_alb_rules

    type = each.value[0]
    to_port = each.value[1]
    from_port = each.value[2]
    protocol = each.value[3]
    cidr_blocks = each.value[4]
}

resource "aws_security_group" "sgroup-asc" {
    name = "sgroup-asc"
    vpc_id = var.vpc-id
}

resource "aws_security_group_rule" "sg-rule-asc" {
    security_group_id = aws_security_group.sgroup-asc.id
    for_each = local.sg_asc_rules

    type = each.value[0]
    to_port = each.value[1]
    from_port = each.value[2]
    protocol = each.value[3]
    source_security_group_id = each.value[4]
}

resource "aws_security_group" "sgroup-nat-id" {
    name = "sgroup-nat-id"
    vpc_id = var.vpc-id
}

resource "aws_security_group_rule" "sgroup-nat-id" {
    security_group_id = aws_security_group.sgroup-nat-id.id

    type = "ingress"
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
# Cho phép giao tiếp giữa các hosts trong vpc
resource "aws_security_group_rule" "sg-rule-asg-ingress" {
    security_group_id = aws_security_group.sgroup-asc.id
    type = "ingress"

    from_port = 0
    to_port = 65535
    protocol = "tcp"
    source_security_group_id = aws_security_group.sgroup-asc.id
}

resource "aws_launch_configuration" "webserver-cluster" {
    name = "terraform-webserver-cluster"
    
    image_id = var.ami-instance
    instance_type = var.type-instance
    key_name = var.key-name
    iam_instance_profile = "${aws_iam_instance_profile.role_profile.name}"
    security_groups = [ "${aws_security_group.sgroup-asc.id}" ]

    associate_public_ip_address = var.associate-public-ip

    lifecycle {
      create_before_destroy = true
    }
}


