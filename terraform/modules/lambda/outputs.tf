output "lambda_arn" {
  value = aws_lambda_function.docker.arn
}
output "security_group_id" {
  value = aws_security_group.lambda.id
}
output "lambda_invoke_arn" {
  value = aws_lambda_function.docker.invoke_arn
}
output "lambda_function_name" {
  value = aws_lambda_function.docker.function_name
}