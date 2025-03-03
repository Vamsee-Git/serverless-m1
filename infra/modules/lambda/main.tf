resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  for_each = toset(var.role_policy_arns)
  role       = aws_iam_role.lambda_exec.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "lambda_log_policy" {
  for_each = toset(var.role_log_policy_arns)
  role       = aws_iam_role.lambda_exec.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "lambda_XRAY_policy" {
  for_each = toset(var.role_XRAY_policy_arns)
  role       = aws_iam_role.lambda_exec.name
  policy_arn = each.value
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  runtime       = var.runtime
  handler       = var.handler
  role          = aws_iam_role.lambda_exec.arn
  tracing_config {
    mode = "Active"  
  }
  environment {
    variables = var.environment_variables
  }

  filename = var.zip_file # Replace with your Lambda code
}
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7  # Set log retention period
 
  tags = {
    Environment = "dev"
  }
}

output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}
