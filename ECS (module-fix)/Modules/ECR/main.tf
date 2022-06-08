
resource "aws_ecr_repository" "ecr" {
  name = var.repo_name

  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}
