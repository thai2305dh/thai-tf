output "password" {
    value = aws_iam_user_login_profile.user1.encrypted_password
}
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
output "loadbalancerdns1" {
  value = aws_elb.elb-1.dns_name
}
output "loadbalancerdns2" {
  value = aws_elb.elb-2.dns_name
}
# output "namemysql" {
#   value = aws_rds
# }