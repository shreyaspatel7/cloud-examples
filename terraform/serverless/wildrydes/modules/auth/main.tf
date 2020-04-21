//Creates conginto user pool
resource "aws_cognito_user_pool" "pool" {
  name = "${var.env}-${var.partner}-${var.app}"
  auto_verified_attributes = ["email"]
  tags = {
    Name        = "${var.env}-${var.partner}-${var.app}"
    Environment = var.env
    Partner     = var.partner
  }
}

//Creates client in the previosuly created user pool
resource "aws_cognito_user_pool_client" "client" {
  name = "${var.env}-${var.partner}-${var.app}"
  
  user_pool_id    = "${aws_cognito_user_pool.pool.id}"
  generate_secret = false
}

