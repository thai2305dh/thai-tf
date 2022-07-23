output "sg-asg-id" {
    value = aws_security_group.sgroup-asc.id
}
output "sgroup-nat-id" {
   value = aws_security_group.sgroup-nat-id.id
}
output "name-asc-gr" {
    value = aws_autoscaling_group.webserver-cluster.name
}
output "alb-dns-name" {
  value = aws_alb.alb.dns_name
}