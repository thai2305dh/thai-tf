resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key_pair_name
  public_key = file("./my-key.pub")
  # public_key = file("${path.module}/my-key.pub")
}