# ALB -----------------------------------------------------------------
resource "aws_alb" "alb" {
    name = "terraform-alb"

    internal = var.alb-internal //Check xem ALB có phải nội bộ không
    security_groups = [ "${aws_security_group.sgroup-alb.id}" ]
    subnets = var.public-subnets

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
    lb_target_group_arn = aws_alb_target_group.alb.arn
    autoscaling_group_name = aws_autoscaling_group.webserver-cluster.id
}
 
# output "alb-dns" {
  
# }
