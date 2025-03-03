provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "sneha-terraform-bucket-us-west-2"
    key            = "usecase6/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = var.table_name
}

# Lambda function to insert data into DynamoDB
module "lambda_add_data" {
  source = "./modules/lambda"
  function_name = "m1-add-sample-data"
  zip_file      = "lambda_function_payload.zip"
  runtime = "python3.10"
  handler = "function1.lambda_handler"
  role_policy_arns = ["arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"]
  depends_on = [module.dynamodb]
  environment_variables = {
    DYNAMODB_TABLE = module.dynamodb.table_name
  }
}

# Lambda function to retrieve data from DynamoDB
module "lambda_get_data" {
  source = "./modules/lambda"
  function_name = "get-users-1"
  zip_file      = "lambda_function_payload.zip"
  runtime = "python3.10"
  handler = "function2.lambda_handler"
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
}