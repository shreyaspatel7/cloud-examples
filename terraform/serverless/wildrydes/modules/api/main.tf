//This data is required for getting current region that we will use to generate source_arn for aws_lambda_permission
data "aws_region" "current" {}

//This data is required for getting current api user's id that we will use to generate source_arn for aws_lambda_permission

data "aws_caller_identity" "current" {}

//This resource is used to create api gateaway
resource "aws_api_gateway_rest_api" "api" {
  name = "${var.env}-${var.partner}-${var.app}"
}

//This will create ride resoucer for the rest API to handle /ride endpoint
resource "aws_api_gateway_resource" "resource" {
  path_part   = "ride"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}


//This will set cognito user session pool as the authorizer of this api  which will be used to authorizer api calls
resource "aws_api_gateway_authorizer" "authorizer" {
  name          = "${var.env}-${var.partner}-${var.app}"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  provider_arns = ["${var.arn}"]
}

//This will allow api gateway to execute the lambda function
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.function_name}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.post_method.http_method}${aws_api_gateway_resource.resource.path}"
}


//This will deploy the REST api in the given stage such as dev, uat, prd
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = ["aws_api_gateway_integration.post_integration"]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${var.env}"

}