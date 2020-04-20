
output "arn" {
  value = module.db.arn
}

output "pool_id" {
  value = module.cognito.pool_id
}
output "pool_client_id" {
  value = module.cognito.pool_client_id
}

output "endpoint" {
  value       = "http://${module.storage.endpoint}"
}

output "bucket_name" {
  value       = module.storage.bucket_name
}
