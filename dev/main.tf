# module "dns_and_ssl" {
#     source = "../modules/dns_and_ssl"
    
#     domain_name = var.domain
#     cname = module.eb.cname
#     zone = module.eb.zone
#     vpc_id = var.vpc_id
# }
// Comment 2 module eb và cloudwwatch để chạy vpc trước. Nếu chạy song song thì env chưa kịp nhận vpc
module "vpc" {
    source = "../modules/vpc"

    vpc_cidr = var.cidr
    vpc_dns_support = var.vpc_dns_support
    vpc_dns_hostnames = var.vpc_dns_hostnames
    public_cidr_1 = var.public_cidr_1
    public_cidr_2 = var.public_cidr_2
    availability_zone = var.availability_zone
    map_public_ip = var.map_public_ip
    private_cidr_1 = var.private_cidr_1
    private_cidr_2 = var.private_cidr_2
}

module "eb" {
    source = "../modules/eb"

    app_tags = var.app_tags
    app_name = var.app_name
    vpc_id = module.vpc.vpc_id
    # ServiceRole = "${aws_iam_instance_profile.beanstalk_service.name}"
    ServiceRole = "role-service-beanstalk"
    IamInstanceProfile = "${aws_iam_instance_profile.beanstalk_ec2.name}"
    ec2_subnets = module.vpc.private_subnets
    elb_subnets = module.vpc.public_subnets
    instance_type = var.instance_type
    disk_size = var.disk_size
    keypair = var.keypair
    sshrestrict = var.sshrestrict
    # certificate = module.dns_and_ssl.certificate
}

module "cloudwatch" {
    source = "../modules/cloudwatch"

    app_tags = var.app_tags
    alarm_sns_topic = var.alarm_sns_topic
    asgName = module.eb.asgName
    envName = module.eb.envName
    lbarn = module.eb.lbarn
}