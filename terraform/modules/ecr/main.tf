resource "aws_ecr_repository" "game_api" {
  name = var.repository_name

  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.game_api.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 10,
      "description": "Retain only the last 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

resource "null_resource" "docker_image" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      #!/bin/bash
      set -e

      echo "Building and pushing new image..."
      aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
      aws ecr get-login-password --region ${data.aws_region.current.name} | docker login --username AWS --password-stdin ${aws_ecr_repository.game_api.repository_url}

      docker build -t game-api ../

      docker tag game-api:latest ${aws_ecr_repository.game_api.repository_url}:latest
      docker push ${aws_ecr_repository.game_api.repository_url}:latest
    EOT
  }

  depends_on = [aws_ecr_repository.game_api]
}

data "aws_region" "current" {}

output "image_build_trigger" {
  value = null_resource.docker_image.id
}