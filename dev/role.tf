# Tạo role phân quyền 
resource "aws_iam_role" "beanstalk_service" {
    name = "beanstalk-service-role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "elasticbeanstalk.amazonaws.com"
        },
        "Action": "sts:AssumeRole",
        "Condition": {
          "StringEquals": {
            "sts:ExternalId": "elasticbeanstalk"
          }
        }
      }
    ]
}
EOF
}
resource "aws_iam_instance_profile" "beanstalk_service" {
    name = "beanstalk-service-user"
    role = "${aws_iam_role.beanstalk_service.name}"
}
resource "aws_iam_role" "beanstalk_ec2" {
    name = "beanstalk-ec2-role"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "beanstalk_ec2" {
    name = "beanstalk-ec2-user"
    role = "${aws_iam_role.beanstalk_ec2.name}"
}

resource "aws_iam_policy_attachment" "beanstalk_service" {
    name = "elastic-beanstalk-service"
    roles = ["${aws_iam_role.beanstalk_service.id}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}
# resource "aws_iam_policy_attachment" "beanstalk_sns" {
#     name = "elastic-beanstalk-service"
#     roles = ["${aws_iam_role.beanstalk_service.id}"]
#     policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkRoleSNS"
# }
# resource "aws_iam_policy_attachment" "beanstalk_core" {
#     name = "elastic-beanstalk-service"
#     roles = ["${aws_iam_role.beanstalk_service.id}"]
#     policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkRoleCore"
# }
# resource "aws_iam_policy_attachment" "beanstalk_web" {
#     name = "elastic-beanstalk-service"
#     roles = ["${aws_iam_role.beanstalk_service.id}"]
#     policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
# }
# resource "aws_iam_policy_attachment" "beanstalk_worker" {
#     name = "elastic-beanstalk-service"
#     roles = ["${aws_iam_role.beanstalk_service.id}"]
#     policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
# }

resource "aws_iam_policy_attachment" "beanstalk_service_health" {
    name = "elastic-beanstalk-service-health"
    roles = ["${aws_iam_role.beanstalk_service.id}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_policy_attachment" "beanstalk_service_update" {
    name = "elastic-beanstalk-service-health"
    roles = ["${aws_iam_role.beanstalk_service.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_worker" {
    name = "elastic-beanstalk-ec2-worker"
    roles = ["${aws_iam_role.beanstalk_ec2.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_web" {
    name = "elastic-beanstalk-ec2-web"
    roles = ["${aws_iam_role.beanstalk_ec2.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_container" {
    name = "elastic-beanstalk-ec2-container"
    roles = ["${aws_iam_role.beanstalk_ec2.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}
