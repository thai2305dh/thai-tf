data "aws_elastic_beanstalk_hosted_zone" "current" {}

resource "aws_elastic_beanstalk_application" "elastic-app" {
    name = var.app_name
}

# resource "aws_elastic_beanstalk_application_version" "elastic-app" {
#     bucket = aws_s3_bucket.quancom-tf2.id
#     key = aws_s3_bucket_object.elastic-app.id
#     application = aws_elastic_beanstalk_application.elastic-app.name
#     name = "eb-tf-app-version-lable"

# }
# resource "aws_s3_bucket_object" "elastic-app" {
#     bucket = aws_s3_bucket.eb_bucket.id
#     key = "beanstalk/app.zip"
#     source = "app.zip"  
# }
data "aws_elastic_beanstalk_solution_stack" "python" {
    most_recent = true

    name_regex = "^64bit Amazon Linux 2 v3.3.14 running Python 3.8$"
}

resource "aws_elastic_beanstalk_environment" "beanstalkenv" {
    name = "${var.app_tags}-Api"
    application = var.app_name
    // Chỉ định ngôn ngữ 
    solution_stack_name = data.aws_elastic_beanstalk_solution_stack.python.name
    //Bậc môi trường lastic Beanstalk. Giá trị hợp lệ là Worker hoặc WebServer
    tier = "WebServer"
    tags = {
        APP_NAME = var.app_tags
    }
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-cloudwatchlogs #
#  Định cấu hình cho các service trong eb
    setting {
        namespace = "aws:ec2:vpc"
        name = "VPCId"
        value = var.vpc_id
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "IamInstanceProfile"
        value     =  var.IamInstanceProfile
    }

     setting {
        namespace = "aws:elasticbeanstalk:environment"
        name      = "ServiceRole"
        value     = var.ServiceRole
    }
    setting {
        namespace = "aws:ec2:vpc"
        name      = "AssociatePublicIpAddress"
        value     =  "True"
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "DisableIMDSv1"
        value     = "true"
    }  

    setting {
        namespace = "aws:ec2:vpc"
        name      = "Subnets"
        value     =  join(",",var.ec2_subnets)
    }

    setting {
        namespace = "aws:ec2:vpc"
        name      = "ELBSubnets"
        value     = join(",", var.elb_subnets)
    }

    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name      = "MatcherHTTPCode"
        value     = "200"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name      = "LoadBalancerType"
        value     = "application"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "InstanceType"
        value     = var.instance_type
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "RootVolumeType"
        value     = "gp3"
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "RootVolumeSize"
        value     = var.disk_size
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "RootVolumeIOPS"
        value     = 3000
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "RootVolumeThroughput"
        value     = 125
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "SSHSourceRestriction" // Được sử dụng để khóa quyền truy cập SSH vào một môi trường
        value     = "tcp, 22, 22, ${var.sshrestrict}" 
    }

    setting {
        namespace = "aws:ec2:vpc"
        name      = "ELBScheme"
        value     = "internet facing"
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name      = "MinSize"
        value     = 2
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name      = "MaxSize"
        value     = 4
    }
// Báo cáo healthy (Basic hoặc enhanced)
    setting {
        namespace = "aws:elasticbeanstalk:healthreporting:system"
        name      = "SystemType"
        value     = "enhanced"
    }
// nó cho phép cập nhật luân phiên cho một môi trường
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name      = "RollingUpdateEnabled"
        value     = true
        
    }
// time-based rolling updates(thời gian), health-based rolling updates(healthy), immutable updates(Các bản cập nhật bất biến khởi chạy một tập hợp đầy đủ instances trong autoscale group mới)
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name      = "RollingUpdateType"
        value     = "Health"
        
    }

    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name      = "MinInstancesInService"
        value     = 2
        
    }

    setting {
        namespace = "aws:elasticbeanstalk:command"
        name      = "DeploymentPolicy"
        value     = "RollingWithAdditionalBatch"
        
    }

    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name      = "MaxBatchSize"
        value     = 1
        
    }

    setting {
        namespace = "aws:elasticbeanstalk:command"
        name      = "BatchSizeType"
        value     = "Percentage"
        
    }

    setting {
        namespace = "aws:elasticbeanstalk:command"
        name      = "BatchSize"
        value     = 30
        
    }

    ###Logging###
    // Sao chép logs từ Ec2 sang S3
    setting {
        namespace = "aws:elasticbeanstalk:hostmanager"
        name      = "LogPublicationControl"
        value     = false
        
    }
    // Chỉ định có tạo nhóm trong Nhật ký CloudWatch cho logs triển khai và proxy cũng như truyền logs từ từng phiên bản trong môi trường của bạn hay không.
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name      = "StreamLogs"
        value     = true
        
    }
    // Chỉ định có xóa các logs group khi môi trường bị xóa hay không. false thì logs sẽ được lưu giữ trong các ngày RetentionInDays.
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name      = "DeleteOnTerminate"
        value     = true
        
    }
    // Số ngày lưu giữ logs trước khi hết hạn.
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name      = "RetentionInDays"
        value     = 7
        
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "EC2KeyName"
        value     = var.keypair
        
    }

    ##Load Balancer ###
    setting { 
        namespace = "aws:elbv2:listener:default"
        name      = "ListenerEnabled"
        value     = true
        }
    // Lắng nghe trên cổng 443
    # setting {
    #     namespace = "aws:elbv2:listener:443"
    #     name      = "ListenerEnabled"
    #     value     = true
    # }
    # setting {
    #     namespace = "aws:elbv2:listener:443"
    #     name      = "Protocol"
    #     value     = "HTTPS"
    # }
    # //Tên tài nguyên Amazon (ARN) của chứng chỉ SSL để liên kết với trình nghe,chỉ áp dụng cho các môi trường có ALB
    # setting {
    #     namespace = "aws:elbv2:listener:443"
    #     name      = "SSLCertificateArns"
    #     value     = var.certificate
    # }
    # // Chỉ định security policy cho ALB
    # setting {
    #     namespace = "aws:elbv2:listener:443"
    #     name      = "SSLPolicy"
    #     value     = "ELBSecurityPolicy-2016-08"
        
    # }
    // Định cấu hình các quy trình bổ sung
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name      = "HealthCheckPath"
        value     = "/"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name      = "Port"
        value     = 80
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name      = "Protocol"
        value     = "HTTP"
    }

    ###Autoscale trigger - Cloudwatch theo CPU### 

    setting {
        namespace = "aws:autoscaling:trigger"
        name      = "MeasureName"
        value     = "CPUUtilization"
        
    }

    setting {
        namespace = "aws:autoscaling:trigger"
        name      = "Statistic"
        value     = "Average"
        
    }

    setting {
        namespace = "aws:autoscaling:trigger"
        name      = "Unit"
        value     = "Percent"
        
    }

    setting {
        namespace = "aws:autoscaling:trigger"
        name      = "LowerThreshold"
        value     = 20
        
    }

    setting {
        namespace = "aws:autoscaling:trigger"
        name      = "LowerBreachScaleIncrement"
        value     = -1
        
    }

    setting {
        namespace = "aws:autoscaling:trigger"
        name      = "UpperThreshold"
        value     = 80
        
    }

    setting {
        namespace = "aws:autoscaling:trigger"
        name      = "UpperBreachScaleIncrement"
        value     = 1
        
    }
    // Bật cập nhật nền tảng được quản lý
    setting {
        namespace = "aws:elasticbeanstalk:managedactions"
        name      = "ManagedActionsEnabled"
        value     = "true"
    }
    // Thời gian cập nhật
    setting {
        namespace = "aws:elasticbeanstalk:managedactions"
        name      = "PreferredStartTime"
        value     = "Tue:10:00"
    }
    // Bản cập nhật mới nhất
    setting {
        namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
        name      = "UpdateLevel"
        value     = "minor"
    }
    // Cập nhật các phiên bản hàng tuần, chỉ định khi ManagedActionsEnabled được đặt thành true.
    setting {
        namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
        name      = "InstanceRefreshEnabled"
        value     = "true"
    }

}

# # Lắng nghe cổng 443
# resource "aws_lb_listener" "https_redirect" {
#   load_balancer_arn = aws_elastic_beanstalk_environment.beanstalkenv.load_balancers[0]
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# data "aws_lb" "eb_lb" {
#   arn = aws_elastic_beanstalk_environment.beanstalkenv.load_balancers[0]
# }

# resource "aws_security_group_rule" "allow_80" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = tolist(data.aws_lb.eb_lb.security_groups)[0]
# }
