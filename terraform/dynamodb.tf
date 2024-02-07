resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "${var.env.prefix}-${var.env.project}-dynamodb"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "jedi_id"

  attribute {
    name = "jedi_id"
    type = "S"
  }

}