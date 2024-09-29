variable "company" {
  type        = string
  description = "Company Name"
  default     = "Bgra"
}

variable "project" {
  type        = string
  description = "Project Name"
}

variable "billiing_code" {
  type        = string
  description = "Billing Code"
}

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS Access Key"
  default     = "eu-west-2"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of public subnet CIDR blocks in the VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}