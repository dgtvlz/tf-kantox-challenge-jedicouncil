resource "aws_dynamodb_table" "locations" {
  name         = "${var.env.prefix}-${var.env.project}-locations-dynamodb"
  billing_mode = var.dynamodb_config.billing_mode
  hash_key     = var.dynamodb_config.hash_key

  attribute {
    name = var.dynamodb_config.hash_key
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = module.kms_key.key_arn
  }

  point_in_time_recovery {
    enabled = var.dynamodb_config.point_in_time_recovery_enabled
  }

}