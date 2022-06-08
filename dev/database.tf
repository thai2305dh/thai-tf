variable "db-public" {
  type = bool
  default = false
}
variable "db-engine" {
  type = string
  default = "mysql"
}
variable "db-engine-version" {
  type = string
  default = "8.0"
}
variable "db-instance-type" {
  type = string
  default = "db.t2.micro"
}
variable "db-name" {
  type = string
  default = "thuvien"
}
variable "username" {
  type = string
  default = "thai"
}
variable "password" {
  type = string
  default = "thai2305"
}
variable "port" {
  type = string
  default = 3306
}

module "database" {
    source = "../modules/database"
    # env = var.env
    vpc-id = "${module.vpc.vpc_id}"
    db-public-access = var.db-public

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
