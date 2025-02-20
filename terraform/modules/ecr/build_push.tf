resource "null_resource" "docker_image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      #!/bin/bash
      set -e

      echo "Building and pushing new image..."
      aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.game_api.repository_url}

      docker build -t game-api ../

      docker tag game-api:latest ${aws_ecr_repository.game_api.repository_url}:latest
      docker push ${aws_ecr_repository.game_api.repository_url}:latest
    EOT
  }

  depends_on = [aws_ecr_repository.game_api]
}
