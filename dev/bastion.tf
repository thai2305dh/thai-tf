# Module cho bastion
module "bastion" {
    source = "../modules/bastion"
    ami = var.bastion-ami //Phiên bản HĐH
    vpc-id = "${module.vpc.vpc_id}"
    type_bastion = var.type_bastion
    # key_name = var.key_name
    key_name = aws_key_pair.my_key_pair.key_name
    bastion-subnet = "${module.vpc.public_subnets[0]}"
    check_public_ip_bastion = true
    ingress-bastion = var.ingress-bastion
    egress-bastion = var.egress-bastion
}