env = {
  name        = "jedic"
  prefix      = "dev"
  region      = "us-east-1"
  key_name    = "development"
  environment = "dev"
  project     = "jedi-council-challenge"
  owner       = "diegogarcia@netrixllc.com"
  costCenter  = "aidata"
}

dynamodb_config = {
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "jedi_id"
}

lambda_update_config = {
  description = "Lambda which receives the updated location of Jedis"
  handler     = "index.lambda_handler"
  runtime     = "python3.8"
  timeout     = 30
}

lambda_get_config = {
  description = "Lambda which retrieves the location of a Jedi"
  handler     = "index.lambda_handler"
  runtime     = "python3.8"
  timeout     = 30
}

kms_config = {
  description             = "KMS for encrypting Jedi's IDs"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}