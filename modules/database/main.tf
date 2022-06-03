resource "aws_db_instance" "rds-instance" {
    identifier = "rds-instance"

    allocated_storage = 5
    engine = var.engine
    engine_version = var.engine-version
    instance_class = var.type

    db_name = var.db-name
    username = var.username
    password = var.password
    port = var.port

    availability_zone =  var.az
    db_subnet_group_name = var.subnet-group
    vpc_security_group_ids = [aws_security_group.sg-rds.id]

    publicly_accessible = var.db-public-access //kiểm soát nếu phiên bản có thể truy cập công khai
    skip_final_snapshot = true
    final_snapshot_identifier = "rds-final"
}

resource "aws_security_group" "sg-rds" {
    name = "sg-rds"
    vpc_id = var.vpc-id
}