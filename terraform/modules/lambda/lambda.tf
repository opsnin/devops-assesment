resource "aws_lambda_function" "docker" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec.arn

  package_type = "Image"
  image_uri    = "${var.ecr_repository_url}:latest"

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.lambda.id]
  }

  depends_on = [aws_iam_role_policy.lambda_exec_policy]

  environment {
    variables = {
      DUMMY_VAR = "dummy"
    }
  }
}
