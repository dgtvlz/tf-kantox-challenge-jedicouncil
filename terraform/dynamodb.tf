resource "aws_dynamodb_table" "locations" {
  name         = "${var.env.prefix}-${var.env.project}-locations-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "jedi_id"

  attribute {
    name = "jedi_id"
    type = "S"
  }

  server_side_encryption {
    enabled = true
    kms_key_arn = module.kms_key.key_arn
  }

}