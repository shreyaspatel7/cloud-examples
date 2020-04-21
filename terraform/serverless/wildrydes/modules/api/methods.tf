/*
POST METHOD RESOURCES
*/

//This will create PODST method for /ride resource
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.authorizer.id}"
}

/*
This will configure method response with CORS header enabled via Access-Control-Allow-Origin 
which will be included in the response made to the api
*/
resource "aws_api_gateway_method_response" "post_cors_200" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.post_method.http_method}"
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = ["aws_api_gateway_method.post_method"]
}


//This will integrate the api gateway to the REST API method
resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.post_method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${var.invoke_arn}"
  depends_on              = ["aws_api_gateway_method.post_method"]

}

/*
OPTIONS METHOD RESOURCES
This section is used to enabled CORS for the API.
****CORS protocall use prefilght  api call to OPTION method on the server and wait for approval before sending the actual post request
"To support CORS, therefore, a REST API resource needs to implement an OPTIONS method 
that can respond to the OPTIONS preflight request with at least the following response 
headers mandated by the Fetch standard"-AWS(https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-cors.html)
*/
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "options_corse_200" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.options_method.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = ["aws_api_gateway_method.options_method"]
}
resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.options_method.http_method}"
  type        = "MOCK"
  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
  depends_on = ["aws_api_gateway_method.options_method"]
}
resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.options_method.http_method}"
  status_code = "${aws_api_gateway_method_response.options_corse_200.status_code}"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = ["aws_api_gateway_method_response.options_corse_200"]
}
