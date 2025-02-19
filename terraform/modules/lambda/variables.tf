variable "ecr_repository_url" {
  description = "The URL of the ECR repository"
  type        = string
}

variable "ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  type        = string
}

variable "private_subnets" {
  description = "A list of private subnet IDs for the Lambda function"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where Lambda resides"
  type        = string
}