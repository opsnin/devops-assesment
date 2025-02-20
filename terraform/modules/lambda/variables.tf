variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string

  validation {
    condition     = length(var.lambda_function_name) > 0 && length(var.lambda_function_name) <= 64 && can(regex("^[a-zA-Z0-9-_]+$", var.lambda_function_name))
    error_message = "The function name must be between 1 and 64 characters and only contain letters, numbers, hyphens, or underscores."
  }
}

variable "ecr_repository_url" {
  type        = string
  description = "The URL of the ECR repository"

  validation {
    condition     = can(regex("^([0-9]{12})\\.dkr\\.ecr\\.([a-z0-9-]+)\\.amazonaws\\.com\\/.+$", var.ecr_repository_url))
    error_message = "Invalid ECR repository URL format. Ensure it follows: '<account-id>.dkr.ecr.<region>.amazonaws.com/<repo-name>'."
  }
}

variable "ecr_repository_arn" {
  type        = string
  description = "The ARN of the ECR repository"

  validation {
    condition     = can(regex("^arn:aws:ecr:[a-z0-9-]+:[0-9]{12}:repository/.+$", var.ecr_repository_arn))
    error_message = "Invalid ECR ARN format. Ensure it follows: 'arn:aws:ecr:<region>:<account-id>:repository/<repo-name>'."
  }
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of private subnet IDs"

  validation {
    condition     = length(var.private_subnets) > 0
    error_message = "At least one private subnet ID must be provided."
  }

  validation {
    condition = alltrue([
      for subnet in var.private_subnets : can(regex("^subnet-[a-f0-9]+$", subnet))
    ])
    error_message = "Each private subnet ID must follow the format 'subnet-xxxxxxxx'."
  }
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"

  validation {
    condition     = can(regex("^vpc-[a-f0-9]+$", var.vpc_id))
    error_message = "Invalid VPC ID format. It must follow 'vpc-xxxxxxxx'."
  }
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}
