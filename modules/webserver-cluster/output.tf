output "sgroup_asg_id" {
    value = aws_security_group.sgroup-asc.id
}
output "sgroup-nat-id" {
   value = aws_security_group.sgroup-asc.id
}
output "name-asc-gr" {
    value = aws_autoscaling_group.webserver-cluster.name
}
