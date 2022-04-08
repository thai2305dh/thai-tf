resource "aws_codedeploy_app" "laravel" {
  compute_platform = "Server"
  name             = "codedeploy-laravel"
}
# resource "aws_codedeploy_deployment_config" "deploy-conf" {
#   deployment_config_name = "CodeDeployDefault.OneAtATime"

#     minimum_healthy_hosts {
#     type  = "HOST_COUNT"
#     value = 1
#   }
# }
resource "aws_codedeploy_deployment_group" "deploy-gr-laravel" {
  app_name               = aws_codedeploy_app.laravel.name
  deployment_group_name  = "deploy-gr-laravel"
  # service_role_arn       = aws_iam_role.role-deploy.arn
  service_role_arn       = "arn:aws:iam::678260741805:role/Code-deploy"
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  autoscaling_groups = ["${aws_autoscaling_group.asg-tf1.name}"]
}
