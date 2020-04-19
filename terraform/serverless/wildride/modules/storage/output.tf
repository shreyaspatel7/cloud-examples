output "endpoint" {
  value = aws_s3_bucket.public_bucket.website_endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.public_bucket.id
}