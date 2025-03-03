resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "_id"

  attribute {
    name = "_id"
    type = "S"
  }
}

output "table_name" {
  value = aws_dynamodb_table.this.name
}