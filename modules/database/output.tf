output "sg_rds_id" {
    value = aws_security_group.sgroup-rds.id
}
output "db_endpoint" {
    value = aws_db_instance.rds-instance.endpoint
}
