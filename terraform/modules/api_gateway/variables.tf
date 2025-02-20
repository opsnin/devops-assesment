variable "lambda_invoke_arn" {
  type        = string
  description = "The ARN of the Lambda function to be invoked by API Gateway"
}
variable "restapi_name" {
  description = "The name of the REST API"
  type        = string
  default     = "MyGameAPI"
}
variable "lambda_function_name" {
  type        = string
  description = "The name of the Lambda function"

  validation {
    condition     = length(var.lambda_function_name) > 0
    error_message = "Lambda function name cannot be empty."
  }
}

variable "endpoints" {
  type = list(object({
    name        = string
    method      = string
    description = string
  }))

  description = "A list of API endpoints including their names, methods, and descriptions"

  validation {
    condition = alltrue([
      for ep in var.endpoints : contains(["GET", "POST", "PUT", "DELETE", "PATCH"], ep.method)
    ])
    error_message = "Each endpoint must have a valid HTTP method: GET, POST, PUT, DELETE, or PATCH."
  }

  validation {
    condition = alltrue([
      for ep in var.endpoints : length(ep.name) > 0
    ])
    error_message = "Each endpoint must have a non-empty name."
  }

  validation {
    condition = alltrue([
      for ep in var.endpoints : length(ep.description) > 5
    ])
    error_message = "Each endpoint description must be at least 5 characters long."
  }
}
