# modules/lambda/variables.tf
variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "zip_file" {
  description = "Path to the Lambda function ZIP file"
  type        = string
}

variable "runtime" {
  description = "Runtime environment for the Lambda function (e.g., python3.10)"
  type        = string
}

variable "handler" {
  description = "Lambda function entry point (e.g., lambda_function.lambda_handler)"
  type        = string
}

variable "role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the Lambda execution role"
  type        = list(string)
}

variable "role_log_policy_arns" {
  description = "List of IAM policy ARNs to attach to the Lambda execution role"
  type        = list(string)
}

variable "environment_variables" {
  description = "Environment variables to pass to the Lambda function"
  type        = map(string)
  default     = {}
}
