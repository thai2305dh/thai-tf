output "bastion-ip" {
  value = aws_instance.bastion.private_ip
}