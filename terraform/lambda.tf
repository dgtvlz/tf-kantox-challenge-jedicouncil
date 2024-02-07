module "lambda_update_locations" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "v7.2.1"

  function_name = "${var.env.prefix}-${var.env.project}-update-locations"
  description   = "Lambda which receives the updated location of Jedis"
  handler       = "index.main"
  runtime       = "nodejs18.x"

  source_path = "../src/update-locations"
}

module "lambda_get_location" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "v7.2.1"

  function_name = "${var.env.prefix}-${var.env.project}-get-location"
  description   = "Lambda which retrieves the location of a Jedi"
  handler       = "index.main"
  runtime       = "nodejs18.x"

  source_path = "../src/get-locations"
}