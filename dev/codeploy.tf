module "codedeploy" {
    source = "../modules/codedeploy"
    # deployment-config-name = var.deployment-config-name
     codedeploy-asc-gr = "${module.webserver-cluster.name-asc-gr}"
     data_bucket_name = "codedeploy-laravel"
}

###https://github.com/Cloud-42/terraform-aws-codedeploy

