//Gọi file cấu hình
data "template_file" "webserver" {
    template = file("./config-file/test.sh")
}

module "ami" {
    source = "../modules/ami"
    vpc-id = "${module.vpc.vpc_id}"
    key_name = aws_key_pair.my_key_pair.key_name
    ami-subnet = "${module.vpc.public_subnets[0]}"
    # check_public_ip_ami = true
    ingress-ami = var.ingress-ami
    egress-ami = var.egress-ami
    user-data = "${data.template_file.webserver.rendered}"
    # key_name = "beanstalk"
}
 output "ggjslg" {
     value = data.template_file.webserver.template
 }

