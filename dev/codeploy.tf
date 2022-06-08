module "codedeploy" {
    source = "../modules/codedeploy"
    deployment-config-name = var.deployment-config-name
    codedeploy-asc-gr = "${module.webserver-cluster.name-asc-gr}"
}


