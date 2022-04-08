resource "aws_iam_role" "roles-scaling" {
  name = "EC2DeployRole"
  assume_role_policy = file("./role.json")
}

resource "aws_iam_role_policy" "ec2" {
  name = "EC2DeployPolicy"
  role = "${aws_iam_role.roles-scaling.id}"
  policy = file("./policy.json")
}