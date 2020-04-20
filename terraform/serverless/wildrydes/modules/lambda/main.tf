
provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/../../app/dev/xyz/api/index.js"
  output_path = "${path.module}/../../app/dev/xyz/api/index.zip"
}
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
