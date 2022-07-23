output "alb-dns-name" {
  description = "The DNS name of the ALB"
  value = module.webserver-cluster.alb-dns-name
}
# output "rds-dns-name" {
#   description  = "The DNS name of the RDS"
#   value = module.database.db-dns-name
# }