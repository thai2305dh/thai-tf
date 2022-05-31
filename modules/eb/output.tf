output "cname" {
  value       = aws_elastic_beanstalk_environment.beanstalkenv.cname
}

output "zone" {
  value       = data.aws_elastic_beanstalk_hosted_zone.current.id
}

output "envName" {
  value       = aws_elastic_beanstalk_environment.beanstalkenv.name
}

output "asgName" {
    value = aws_elastic_beanstalk_environment.beanstalkenv.autoscaling_groups[0]
}

output "lbarn" {
    value = aws_elastic_beanstalk_environment.beanstalkenv.load_balancers[0]
}