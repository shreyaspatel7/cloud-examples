
//We are using this provider to zip the index.js file for lambda that will handle api requests
provider "archive" {}

//this will zip the file 
data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/../../app/dev/${var.partner}/api/index.js"
  output_path = "${path.module}/../../app/dev/${var.partner}/api/index.zip"
}

//This resource will create a lambda function with nodeJS 10 and use the file we generated in the previous archive_file step
resource "aws_lambda_function" "lambda" {

  function_name = "${var.env}-${var.partner}-${var.app}"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "index.handler"

  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"

  runtime = "nodejs10.x"

  tags = {
    Name        = "${var.env}-${var.partner}-${var.app}"
    Environment = var.env
    Partner     = var.partner
  }

}
