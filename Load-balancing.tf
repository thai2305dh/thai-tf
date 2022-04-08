# Elastic Load Blancer
resource "aws_elb" "elb-1" {
  name = "terraform-elb-1"
  
    subnets = [ aws_subnet.public-subnet-1a.id ]
    # availability_zones = [ "us-east-2a" ]
    security_groups = [ aws_security_group.tf-sg.id ]

    cross_zone_load_balancing = true
    idle_timeout = 60  //Thời gian mà kết nối được phép ở chế độ chờ
    connection_draining = true
    connection_draining_timeout = 300 // Thời gian để cho phép hết các kết nối
    health_check {
    target = "TCP:8080"
    interval = 30 // THời gian giữa mỗi lần check
    timeout = 3 
    healthy_threshold = 3 //số lần check thấy khỏe
    unhealthy_threshold = 2 
  }

  listener {
    lb_port = 80  // Listen port load balancer
    lb_protocol = "http"
    instance_port = 8080 //Listen port instance
    instance_protocol = "http"
  }
}
resource "aws_elb" "elb-2" {
  name = "terraform-elb-2"

  subnets = [ aws_subnet.public-subnet-1b.id ]
  # availability_zones = ["us-east-2b"]
  security_groups = [ aws_security_group.tf-sg.id ]
  # instances                   = [aws_instance.foo.id]
  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300
  
  health_check {
    target = "TCP:8080"
    interval = 30
    timeout = 3
    healthy_threshold = 3
    unhealthy_threshold = 2
  }

  listener {
    lb_port = 80
    lb_protocol = "http"

    instance_port = 8080
    instance_protocol = "http"
  }
}