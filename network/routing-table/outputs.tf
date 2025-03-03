output "route_ids" {
  description = "The IDs of the created routes."
  value       = aws_route.this[*].id
}