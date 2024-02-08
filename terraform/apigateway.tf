resource "aws_api_gateway_rest_api" "jedi_api" {
  name        = "${var.env.prefix}-${var.env.project}-apigw"
  description = "Jedi's locations API Gateway"
}

resource "aws_api_gateway_resource" "get_jedi_resource" {
  rest_api_id = aws_api_gateway_rest_api.jedi_api.id
  parent_id   = aws_api_gateway_rest_api.jedi_api.root_resource_id
  path_part   = "get-jedi"
}

resource "aws_api_gateway_resource" "update_jedi_resource" {
  rest_api_id = aws_api_gateway_rest_api.jedi_api.id
  parent_id   = aws_api_gateway_rest_api.jedi_api.root_resource_id
  path_part   = "update-jedi"
}

resource "aws_api_gateway_method" "get_jedi_method" {
  rest_api_id   = aws_api_gateway_rest_api.jedi_api.id
  resource_id   = aws_api_gateway_resource.get_jedi_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_jedi_integration" {
  rest_api_id             = aws_api_gateway_rest_api.jedi_api.id
  resource_id             = aws_api_gateway_resource.get_jedi_resource.id
  http_method             = aws_api_gateway_method.get_jedi_method.http_method
  integration_http_method = "POST" #Lambda function can only be invoked via POST.
  type                    = "AWS_PROXY"
  uri                     = module.lambda_get_location.lambda_function_invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_permission_get_jedi" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_get_location.lambda_function_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.jedi_api.execution_arn}/*/*"
}

resource "aws_api_gateway_method" "update_jedi_method" {
  rest_api_id   = aws_api_gateway_rest_api.jedi_api.id
  resource_id   = aws_api_gateway_resource.update_jedi_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "update_jedi_integration" {
  rest_api_id             = aws_api_gateway_rest_api.jedi_api.id
  resource_id             = aws_api_gateway_resource.update_jedi_resource.id
  http_method             = aws_api_gateway_method.update_jedi_method.http_method
  integration_http_method = "POST" #Lambda function can only be invoked via POST.
  type                    = "AWS_PROXY"
  uri                     = module.lambda_update_locations.lambda_function_invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_permission_update_jedi" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_update_locations.lambda_function_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.jedi_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "jedi_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.jedi_api.id
  stage_name  = "dev"

  depends_on = [aws_api_gateway_integration.update_jedi_integration]
}
