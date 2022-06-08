//Gọi file cấu hình
data "template_file" "webserver" {
    template = file("${path.module}/config-file/webserver.sh")
}

module "ami" {
    source = "../modules/ami"
    user-data = "${data.template_file.webserver.rendered}"
    key_name = "beanstalk"
}
