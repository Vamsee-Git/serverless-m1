provider "aws" {
  region = var.aws_region
}

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = var.table_name
}

# Lambda function to insert data into DynamoDB.
module "lambda_add_data" {
  source = "./modules/lambda"
  function_name = "lambda-write-data"
  zip_file    = "lambda_add.zip"
  runtime = "python3.10"
  handler = "lambda_add.lambda_handler"
  role_policy_arns = ["arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"]
  depends_on = [module.dynamodb]
  environment_variables = {
    DYNAMODB_TABLE = module.dynamodb.table_name
  }
}

# Lambda function to retrieve data from DynamoDB
module "lambda_get_data" {
  source = "./modules/lambda"
  function_name = "lambda-read-data"
  zip_file      = "lambda_read.zip"
  runtime = "python3.10"
  handler = "lambda_read.lambda_handler"
  role_policy_arns = ["arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"]
  depends_on = [module.dynamodb]
  environment_variables = {
    DYNAMODB_TABLE = module.dynamodb.table_name
  }
}

# API Gateway to trigger the get-users Lambda function
module "api_gateway" {
  source = "./modules/api_gateway"
  lambda_function_name = module.lambda_get_data.function_name
  lambda_invoke_arn = module.lambda_get_data.invoke_arn
  resource_path = "users"
  http_method = "GET"
  stage_name    = "dev"
}
