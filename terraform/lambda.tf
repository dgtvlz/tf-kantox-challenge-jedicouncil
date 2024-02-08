module "lambda_update_locations" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "v7.2.1"

  function_name = "${var.env.prefix}-${var.env.project}-update-locations"
  description   = var.lambda_update_config.description
  handler       = var.lambda_update_config.handler
  runtime       = var.lambda_update_config.runtime
  timeout       = var.lambda_update_config.timeout

  environment_variables = {
    REGION              = var.env.region
    DYNAMODB_TABLE_NAME = aws_dynamodb_table.locations.id
  }

  source_path = "../src/update-locations"
}

resource "aws_iam_policy" "lambda_update_locations_permissions_policy" {
  name        = "${var.env.prefix}-${var.env.project}-update-locations-policy"
  description = "Policy to grant permissions to Lambda Update Locations"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:BatchWriteItem"
        ],
        Resource = aws_dynamodb_table.locations.arn
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt"
        ],
        Resource = module.kms_key.key_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_update_locations_permissions_policy_attachment" {
  role       = module.lambda_update_locations.lambda_role_name
  policy_arn = aws_iam_policy.lambda_update_locations_permissions_policy.arn
}

module "lambda_get_location" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "v7.2.1"

  function_name = "${var.env.prefix}-${var.env.project}-get-location"
  description   = var.lambda_get_config.description
  handler       = var.lambda_get_config.handler
  runtime       = var.lambda_get_config.runtime
  timeout       = var.lambda_get_config.timeout

  environment_variables = {
    REGION              = var.env.region
    DYNAMODB_TABLE_NAME = aws_dynamodb_table.locations.id
  }

  source_path = "../src/get-location"
}

resource "aws_iam_policy" "lambda_get_location_permissions_policy" {
  name        = "${var.env.prefix}-${var.env.project}-get-location-policy"
  description = "Policy to grant permissions to Lambda Get Location"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem"
        ],
        Resource = aws_dynamodb_table.locations.arn
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt"
        ],
        Resource = module.kms_key.key_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_get_location_permissions_policy_attachment" {
  role       = module.lambda_get_location.lambda_role_name
  policy_arn = aws_iam_policy.lambda_get_location_permissions_policy.arn
}