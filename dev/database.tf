# Module db
module "database" {
    source = "../modules/database"
    # env = var.env
    vpc-id = "${module.vpc.vpc_id}"
    db-public-access = false

    engine = var.db-engine
    engine-version = var.db-engine-version
    type = var.db-instance-type

    db-name = var.db-name
    username = var.username
    password = var.password
    port = var.port

    az = "${module.vpc.az[0]}"
    subnet-group = "${module.vpc.db_subnet_group}"
}

# Allow MySQL traffics form Webserver:
resource "aws_security_group_rule" "sg-ingress" {
    security_group_id = "${module.database.sg_rds_id}"
    type = "ingress"

    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    source_security_group_id = "${module.webserver-cluster.sgroup_asg_id}"
}
