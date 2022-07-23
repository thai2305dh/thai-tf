resource "aws_iam_role" "roles-scaling" {
    name = "Autoscale-DeployRole"
    assume_role_policy = file("../modules/codedeploy/role.json")
}

resource "aws_iam_role_policy" "ec2" {
    name = "Autoscale-DeployPolicy"
    role = "${aws_iam_role.roles-scaling.id}"
    policy = file("../modules/codedeploy/policy.json")
}

# resource "aws_iam_role" "roles-scaling" {
#   name = "codeploy-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": [
#           "codedeploy.amazonaws.com"
#         ]
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }
# # ---------------------------------
# # Attach default Codedeploy policy to Role
# # ---------------------------------
# resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
#   role       = aws_iam_role.roles-scaling.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
# }

