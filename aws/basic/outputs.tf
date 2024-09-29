output "public_dns" {
  description = "Public DNS Name"
  value       = "http://${aws_lb.nginx.dns_name}"
}