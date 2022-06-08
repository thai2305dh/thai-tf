resource "aws_iam_role" "roles-scaling" {
    name = "Autoscale-DeployRole"
    assume_role_policy = file("../modules/codedeploy/role.json")
}

resource "aws_iam_role_policy" "ec2" {
    name = "Autoscale-DeployPolicy"
    role = "${aws_iam_role.roles-scaling.id}"
    policy = file("../modules/codedeploy/policy.json")
}