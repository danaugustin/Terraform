resource "aws_customer_gateway" "this" {
  bgp_asn    = var.customer_gateway_bgp_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"
}

resource "aws_ec2_transit_gateway_route" "this" {
  count                           = length(var.routes)
  transit_gateway_route_table_id  = var.transit_gateway_route_table_id
  transit_gateway_attachment_id   = aws_vpn_connection.this.transit_gateway_attachment_id
  destination_cidr_block          = var.routes[count.index].destination_cidr_block
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_vpn_connection.this.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
}

resource "aws_vpn_connection" "this" {
  customer_gateway_id = aws_customer_gateway.this.id
  transit_gateway_id  = var.transit_gateway_id
  type                = "ipsec.1"

  tunnel1_inside_cidr       = var.tunnel1_inside_cidr
  tunnel2_inside_cidr       = var.tunnel2_inside_cidr

  tunnel1_preshared_key     = var.tunnel1_preshared_key
  tunnel2_preshared_key     = var.tunnel2_preshared_key

  static_routes_only        = var.static_routes_only

  # Tunnel 1 configuration
  tunnel1_ike_versions                 = var.tunnel1_ike_versions
  tunnel1_phase1_dh_group_numbers      = var.tunnel1_phase1_dh_group_numbers
  tunnel1_phase1_encryption_algorithms = var.tunnel1_phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.tunnel1_phase1_integrity_algorithms
  tunnel1_phase1_lifetime_seconds      = var.tunnel1_phase1_lifetime_seconds
  tunnel1_phase2_dh_group_numbers      = var.tunnel1_phase2_dh_group_numbers
  tunnel1_phase2_encryption_algorithms = var.tunnel1_phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = var.tunnel1_phase2_integrity_algorithms
  tunnel1_phase2_lifetime_seconds      = var.tunnel1_phase2_lifetime_seconds
  tunnel1_dpd_timeout_action           = var.tunnel1_dpd_timeout_action
  tunnel1_dpd_timeout_seconds          = var.tunnel1_dpd_timeout_seconds
  tunnel1_replay_window_size           = var.tunnel1_replay_window_size
  tunnel1_startup_action               = var.tunnel1_startup_action

  # Tunnel 2 configuration
  tunnel2_ike_versions                 = var.tunnel2_ike_versions
  tunnel2_phase1_dh_group_numbers      = var.tunnel2_phase1_dh_group_numbers
  tunnel2_phase1_encryption_algorithms = var.tunnel2_phase1_encryption_algorithms
  tunnel2_phase1_integrity_algorithms  = var.tunnel2_phase1_integrity_algorithms
  tunnel2_phase1_lifetime_seconds      = var.tunnel2_phase1_lifetime_seconds
  tunnel2_phase2_dh_group_numbers      = var.tunnel2_phase2_dh_group_numbers
  tunnel2_phase2_encryption_algorithms = var.tunnel2_phase2_encryption_algorithms
  tunnel2_phase2_integrity_algorithms  = var.tunnel2_phase2_integrity_algorithms
  tunnel2_phase2_lifetime_seconds      = var.tunnel2_phase2_lifetime_seconds
  tunnel2_dpd_timeout_action           = var.tunnel2_dpd_timeout_action
  tunnel2_dpd_timeout_seconds          = var.tunnel2_dpd_timeout_seconds
  tunnel2_replay_window_size           = var.tunnel2_replay_window_size
  tunnel2_startup_action               = var.tunnel2_startup_action

  tags = {
    Name = var.vpn_name
  }
}