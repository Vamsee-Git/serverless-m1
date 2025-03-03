# Root variables.tf
variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}