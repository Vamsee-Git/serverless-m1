resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userid"

  attribute {
    name = "userid"
    type = "S"
  }
}

output "table_name" {
  value = aws_dynamodb_table.this.name
}
