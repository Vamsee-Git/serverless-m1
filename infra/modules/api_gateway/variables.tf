variable "resource_path" {
  description = "The resource path for the API."
  type        = string
}

variable "http_method" {
  description = "The HTTP method for the API."
  type        = string
}

variable "lambda_invoke_arn" {
  description = "The Lambda invoke ARN."
  type        = string
}

variable "lambda_function_name" {
  description = "The Lambda function name."
  type        = string
}

variable "api_gateway_cloudwatch_role_arn" {
  description = "The ARN of the IAM role for API Gateway CloudWatch logging"
  type        = string
}

variable "stage_name" {
  description = "The name of the stage (e.g., dev, prod)."
  type        = string
}
