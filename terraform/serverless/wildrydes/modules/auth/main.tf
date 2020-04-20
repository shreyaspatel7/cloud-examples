resource "aws_cognito_user_pool" "pool" {
  name = "${var.env}-${var.partner}-${var.app}"

  tags = {
    Name        = "${var.env}-${var.partner}-${var.app}"
    Environment = var.env
    Partner     = var.partner
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${var.env}-${var.partner}-${var.app}"

  user_pool_id    = "${aws_cognito_user_pool.pool.id}"
  generate_secret = false
}

