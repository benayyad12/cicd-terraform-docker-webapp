resource "aws_dynamodb_table" "statelock" {
  name         = var.dynamodb_name
  billing_mode = var.pay_mode
  hash_key     = var.hkey

  attribute {
    name = "LockID"
    type = "S"
  }
}