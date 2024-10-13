variable "bucket_name" {
  type        = string
  description = "S3 Bucket name"
}

variable "elb_service_account_arn" {
  type        = string
  description = "Load Balancer Service Account ARN"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to apply to S3 resources"
  default     = {}
}