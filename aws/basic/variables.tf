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

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map public ip address to instances in subnet"
  default     = true
}

variable "vpc_public_subnet_count" {
  type        = number
  description = "Number of public subnets"
  default     = 2
}

variable "nginx_instance_count" {
  type        = number
  description = "Number of Nginx instances"
  default     = 2
}

variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources"
  default     = "bgra-web-app"
}

variable "environment" {
  type        = string
  description = "Environment for the resource"
  default     = "dev"
}
