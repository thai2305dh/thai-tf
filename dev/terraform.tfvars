region = "us-east-1"

domain = "example.com"

app_tags = "Example"

app_name = "Example-App"

# vpc_id = "vpc-0a7235d43cdccbdd5"

# ec2_subnets = ["subnet-016434b55b9575405","subnet-0d98b9ac46c357bc7"]

# elb_subnets = ["subnet-0fd379675d08dde6c","subnet-03194700b662cf307"]

instance_type = "t2.micro"

disk_size = "20"

keypair = "beanstalk"

sshrestrict="0.0.0.0/0"

alarm_sns_topic = "arn:aws:sns:us-east-1:123456788900:TOPIC"

cidr = "10.0.0.0/16"

vpc_dns_support = true

vpc_dns_hostnames = true

public_cidr_1 = "10.0.1.0/24"

public_cidr_2 ="10.0.3.0/24"

private_cidr_1 = "10.0.2.0/24"

private_cidr_2 = "10.0.4.0/24"

availability_zone = ["us-east-1a", "us-east-1c"]

map_public_ip = true