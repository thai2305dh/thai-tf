# Tạo DB instance
resource "aws_db_instance" "db-instance-tf" {
    identifier = "db-instance-tf" //tên instance
    allocated_storage = 10 // Bộ nhớ được cấp phát
    storage_type = "gp2" // SSD
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t2.micro"
    # vpc_security_group_ids = [ "${aws_security_group.sg-rds-mysql-terraform.id}" ]
    db_subnet_group_name = aws_db_subnet_group.pr-subnet-group-tf.name //CHỉ định subnet của instance

# DB_CONNECTION=mysql
    name = "thuvien"
    username = "thai"
    password = "thai2305"
    parameter_group_name = "default.mysql8.0"
    availability_zone = "us-east-2a"
    skip_final_snapshot  = false // Chỉ định 1 ảnh chụp nhanh nếu instance bị xóa
  
  tags = {
      name = "MySQL laravel instance"
  }
}