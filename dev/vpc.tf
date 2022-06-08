module "vpc" {
    source = "../modules/vpc"
    # environment = var.env
    cidr-vpc = var.cidr
    dns-hostname = true
    # subnet-nat = var.subnet-nat
    subnet-nat = "${module.vpc.public_subnets[0]}"
    public-subnet-stt = var.public-all
    private-subnet-stt = var.private-all
    # vpc_id = module.vpc.vpc_id
}
