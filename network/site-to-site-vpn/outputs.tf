output "customer_gateway_id" {
  description = "The ID of the Customer Gateway"
  value       = aws_customer_gateway.this.id
}

output "vpn_connection_id" {
  description = "The ID of the VPN Connection"
  value       = aws_vpn_connection.this.id
}

output "vpn_connection_tunnel1_address" {
  description = "The IP address of the first VPN tunnel"
  value       = aws_vpn_connection.this.tunnel1_address
}

output "vpn_connection_tunnel2_address" {
  description = "The IP address of the second VPN tunnel"
  value       = aws_vpn_connection.this.tunnel2_address
}

output "transit_gateway_attachment_id" {
  description = "The IP address of the second VPN tunnel"
  value       = aws_vpn_connection.this.transit_gateway_attachment_id
}