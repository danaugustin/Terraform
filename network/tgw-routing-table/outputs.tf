output "route_ids" {
  description = "The IDs of the created routes."
  value       = aws_ec2_transit_gateway_route.this[*].id
}