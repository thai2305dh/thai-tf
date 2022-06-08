# subnet-group cho database
resource "aws_db_subnet_group" "subnet-group" {
    subnet_ids = values(aws_subnet.private-subnets)[*].id
    name = "terraform-private-subnet-group"
}