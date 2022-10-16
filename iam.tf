#Dinh nghia IAM va nhom
resource "aws_iam_user" "user1" {
    name = "user1"
}

resource "aws_iam_user" "user2" {
    name = "user2"
}

resource "aws_iam_group" "tf-group" {
    name = "tf-group"
}

# Sau khi tạo user
resource "aws_iam_group_membership" "assigment" {
    name =  "assigment"
    users = [
        aws_iam_user.user1.name,
        aws_iam_user.user2.name
    ]
    group = aws_iam_group.tf-group.name
}

resource "aws_iam_user_login_profile" "user1" {
    user = aws_iam_user.user1.name
    pgp_key = "keybase:thainguyen23"
}

# resource "aws_iam_policy" "tf-policy" {
#     name = "tf-policy"
#     path = "/"//"arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
# // Tạo 1 policy cho phép user đăng nhập vào EC2 nhưng k cho xóa và thay đổi policy
# # JSON
#     policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ecr:GetAuthorizationToken",
#                 "ecr:BatchCheckLayerAvailability",
#                 "ecr:GetDownloadUrlForLayer",
#                 "ecr:GetRepositoryPolicy",
#                 "ecr:DescribeRepositories",
#                 "ecr:ListImages",
#                 "ecr:DescribeImages",
#                 "ecr:BatchGetImage",
#                 "ecr:GetLifecyclePolicy",
#                 "ecr:GetLifecyclePolicyPreview",
#                 "ecr:ListTagsForResource",
#                 "ecr:DescribeImageScanFindings",
#                 "ecr:InitiateLayerUpload",
#                 "ecr:UploadLayerPart",
#                 "ecr:CompleteLayerUpload",
#                 "ecr:PutImage"
#             ],
#             "Resource": "*"
#         }
#     ]
# })
# }
resource "aws_iam_policy" "deploy-policy" {
  name = "deploy-policy"
  path = "/"//"arn:aws:iam::aws:policy/AutoScalingFullAccess-2"
  # JSON
    policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:CompleteLifecycleAction",
        "autoscaling:DeleteLifecycleHook",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLifecycleHooks",
        "autoscaling:PutLifecycleHook",
        "autoscaling:RecordLifecycleActionHeartbeat"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "tag:GetTags",
        "tag:GetResources"
      ],
      "Resource": "*"
    }
  ]
})
}
resource "aws_iam_role" "tf-role" {
    name = "tf-role"
    
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
# resource "aws_iam_role" "role-deploy" {
#     name = "role-deploy"
    
#   assume_role_policy = <<EOF
#   {

#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": [
#           "codedeploy.amazonaws.com"
#           "ec2.amazonaws.com"
#         ]
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }
# # Attach(gán) role cho user
# resource "aws_iam_policy_attachment" "test-attach" {
#   name       = "test-attachment"
#   users      = [aws_iam_user.user1.name,
#         aws_iam_user.user2.name
#   ]
#   roles      = [aws_iam_role.tf-role.name]
#   groups     = [aws_iam_group.tf-group.name]
# #   policy_arn = [
# # arn:aws:iam::aws:policy/AmazonEC2FullAccess, arn:aws:iam::aws:policy/AmazonS3FullAccess, arn:aws:iam::aws:policy/AWSCodeDeployFullAccess]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }


# resource "aws_iam_role_policy_attachment" "access_ec2" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
#   role       = aws_iam_role.role-deploy.name
# }
# resource "aws_iam_role_policy_attachment" "access_deploy" {
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
#   role       = aws_iam_role.role-deploy.name
# }
# resource "aws_iam_role_policy_attachment" "access_s3" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   role       = aws_iam_role.role-deploy.name
# }
# resource "aws_iam_role_policy_attachment" "access_autosc" {
#   policy_arn = aws_iam_policy.deploy-policy.arn
#   role       = aws_iam_role.role-deploy.name
# }


