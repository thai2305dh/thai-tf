# create Instance cho 2 autoscalling group
resource "aws_iam_instance_profile" "addrole" {
  name = "EC2DeployInstance"
  role =  aws_iam_role.roles-scaling.name
}
# resource "aws_iam_instance_profile" "ec2" {
#   name = "EC2DeployInstance"
#   role = ["${aws_iam_role.ec2.name}"]
# }
resource "aws_launch_configuration" "launch_instance_config-1" {
  
    name = "client"
    image_id = var.terraform-ubuntu-ami //Phiên bản HĐH
    instance_type = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.addrole.id}"
    security_groups = ["${aws_security_group.tf-sg-private.id}"] // sercurity group cho instance
    key_name = "key"
    associate_public_ip_address = true

  lifecycle {
      create_before_destroy = true
  }
}
resource "aws_launch_configuration" "launch_instance_config-2b" {
  
    name = "server"
    image_id = var.terraform-ubuntu-ami //Phiên bản HĐH
    iam_instance_profile = "${aws_iam_instance_profile.addrole.id}"
    security_groups = ["${aws_security_group.tf-sg-private.id}"]
    instance_type = "t2.micro"
    key_name = "key"
    associate_public_ip_address = true


  lifecycle {
      create_before_destroy = true
  }
}

# Autoscalling group
resource "aws_autoscaling_group" "asg-tf1" {
  name                      = "asg-tf1"
  launch_configuration = aws_launch_configuration.launch_instance_config-1.id // Instance mẫu
  vpc_zone_identifier = [ aws_subnet.private-subnet-1a.id ]
  
  min_size = 1 // Số lượng instance tối thiểu
  max_size = 3  // Số lượng instance tối đa

  load_balancers = [aws_elb.elb-1.name] // Gán cho ELB
  health_check_type = "ELB"  
  # role_arn                = aws_iam_role.roles-scaling.id
  tag {
    key = "Name"
    value = "terraform-asg-client"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_group" "asg-tf2" {
  name                      = "asg-tf2"
  launch_configuration = aws_launch_configuration.launch_instance_config-2b.id

  vpc_zone_identifier = [ aws_subnet.private-subnet-1b.id ]
  
  min_size = 1
  max_size = 3

  load_balancers = [aws_elb.elb-2.name]
  health_check_type = "ELB"  

  tag {
    key = "Name"
    value = "terraform-asg-server"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_attachment" "asg_public_elb-1" {
  autoscaling_group_name = "${aws_autoscaling_group.asg-tf1.id}"
  elb                    = "${aws_elb.elb-1.id}"
}
resource "aws_autoscaling_attachment" "asg_public_elb-2" {
  autoscaling_group_name = "${aws_autoscaling_group.asg-tf2.id}"
  elb                    = "${aws_elb.elb-2.id}"
}

# Setup alarm creat or terminate launch configuration
resource "aws_autoscaling_policy" "add_instance" {
  name = "AddCapacityPolicy"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = "600"
  autoscaling_group_name = "${aws_autoscaling_group.asg-tf1.name}"
}
resource "aws_autoscaling_policy" "remove_instance" {
  name = "RemoveCapacityPolicy"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = "600"
  autoscaling_group_name = "${aws_autoscaling_group.asg-tf1.name}"
}

/*--------------------------------------------------
 * Cloudwatch Alerts For Scaling
 *-------------------------------------------------*/
resource "aws_cloudwatch_metric_alarm" "add_instance" {
  alarm_name = "AddInstanceAlert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "85"
  dimensions = {
      AutoScalingGroupName = "${aws_autoscaling_group.asg-tf1.name}"
  }
  alarm_description = "This metric monitor ec2 cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.add_instance.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "remove_instance" {
  alarm_name = "RemoveInstanceAlert"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "30"
  dimensions = {
      AutoScalingGroupName = "${aws_autoscaling_group.asg-tf1.name}"
  }
  alarm_description = "This metric monitor ec2 cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.remove_instance.arn}"]
}

output "id" {value = "${aws_autoscaling_group.asg-tf1.id}"}