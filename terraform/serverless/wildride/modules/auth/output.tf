output "pool_id" {
  value = aws_cognito_user_pool.pool.id
}

output "pool_client_id" {
  value = aws_cognito_user_pool_client.client.id
}


output "pool_client_arn" {
  value = aws_cognito_user_pool.pool.arn
}
