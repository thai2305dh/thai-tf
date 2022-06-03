module "vpc" {
    source = "../modules/vpc"
    # environment = var.env
    cidr-vpc = var.cidr
    dns-hostname = true
    subnet-nat = var.subnet-nat
    public-subnet-stt = var.public
    private-subnet-stt = var.private
    vpc_id = module.vpc.vpc_id
}
