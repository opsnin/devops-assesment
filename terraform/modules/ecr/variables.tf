variable "repository_name" {
  type        = string
  description = "The name of the repository"

  validation {
    condition     = length(var.repository_name) > 0
    error_message = "Repository name cannot be empty."
  }

  validation {
    condition     = length(var.repository_name) <= 100
    error_message = "Repository name cannot exceed 100 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.repository_name))
    error_message = "Repository name can only contain alphanumeric characters, dots (.), underscores (_), and hyphens (-)."
  }
}
variable "aws_region" {
  description = "The AWS region"
  type        = string
}
