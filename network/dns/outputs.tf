output "record" {
  description = "The CNAME record"
  value       = aws_route53_record.this.name
}