output "web_bucket" {
  description = "S3 bucket object"
  value       = aws_s3_bucket.web_bucket
}

output "instance_profile" {
  description = "Instance profile object"
  value       = aws_iam_instance_profile.nginx_profile
}
