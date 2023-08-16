resource "aws_customer_gateway" "dev_qts_cgw" {
  bgp_asn    = var.bgp_asn
  ip_address = var.cgw_ip_address
  type       = "ipsec.1"
  tags = {
    Name = var.aws_cgw_name
  }
}

resource "aws_vpc" "dev_qts_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.aws_vpc_name
  }
}

#Create an ACL to manage traffic in the VPC
resource "aws_network_acl" "dev_qts_vpc_acl" {
  vpc_id = aws_vpc.dev_qts_vpc.id
  tags = {
    Name = var.aws_network_acl_name
  }
}

#Create an ACL rule to allow traffic through the VPC
resource "aws_network_acl_rule" "outbound_rule_0" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.vpc_subnet_cidr_1
}

#Create an ACL rule to allow traffic through the VPC
resource "aws_network_acl_rule" "outbound_rule_1" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = 101
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.onprem_cidr_hw_lab
}

#Create an ACL rule to allow traffic through the VPC
resource "aws_network_acl_rule" "outbound_rule_2" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = 102
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.onprem_cidr_esx_lab
}

#Create an ACL rule to allow traffic through the VPC
resource "aws_network_acl_rule" "outbound_rule_3" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = 103
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.onprem_cidr_eve_lab
}

#Create an ACL rule to allow traffic through the VPC
resource "aws_network_acl_rule" "outbound_rule_4" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = 104
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.onprem_cidr_gpvpn
}

#Create an ACL rule to allow traffic through the VPC
resource "aws_network_acl_rule" "inbound_rule_0" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = 200
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.onprem_cidr_hw_lab
}

#Create an ACL rule to allow traffic through the VPC
resource "aws_network_acl_rule" "inbound_rule_1" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = 201
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.onprem_cidr_esx_lab
}

#Create an ACL rule to allow traffic through the VPC
resource "aws_network_acl_rule" "inbound_rule_2" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = 202
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.onprem_cidr_eve_lab
}

#Create an ACL rule to allow traffic through the VPC
resource "aws_network_acl_rule" "inbound_rule_3" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = 203
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.vpc_subnet_cidr_1
}

#Create an ACL rule to allow traffic through the VPC
resource "aws_network_acl_rule" "inbound_rule_4" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = 204
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.onprem_cidr_gpvpn
}

# Create the subnet to be used for Dev internal
resource "aws_subnet" "dev_qts_subnet" {
  vpc_id                  = aws_vpc.dev_qts_vpc.id
  cidr_block              = var.vpc_subnet_cidr_1
  availability_zone       = var.region_az
  map_public_ip_on_launch = false
  
  tags = {
    Name = var.aws_subnet_name
  }
}

# Create network ACL association for the subnet
resource "aws_network_acl_association" "dev_qts_subnet_acl" {
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  subnet_id      = aws_subnet.dev_qts_subnet.id
}

# Create a Transit Gateway
resource "aws_ec2_transit_gateway" "dev_qts_tgw" {
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

    tags = {
    Name = var.aws_tgw_name
  }
}

# Create a Transit Gateway Route Table to be shared with connected VPCs
resource "aws_ec2_transit_gateway_route_table" "dev_qts_tgw_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.dev_qts_tgw.id

  tags = {
    Name = var.tgw_rt_name
  }
}

# Create the VPN tunnel
module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "3.6.0"

  vpc_id = aws_vpc.dev_qts_vpc.id

  transit_gateway_id               = aws_ec2_transit_gateway.dev_qts_tgw.id
  customer_gateway_id              = aws_customer_gateway.dev_qts_cgw.id
  vpn_connection_static_routes_only = true
  vpn_connection_static_routes_destinations = ["var.onprem_cidr_hw_lab", "var.onprem_cidr_esx_lab", "var.onprem_cidr_eve_lab", "var.onprem_cidr_gpvpn"]

  tunnel_inside_ip_version = "ipv4"

  # Tunnel 1 configuration
  tunnel1_inside_cidr                   = var.tunnel1_inside_cidr
  tunnel1_preshared_key                 = var.tunnel1_preshared_key
  tunnel1_ike_versions                  = var.tunnel1_ike_versions
  tunnel1_phase1_dh_group_numbers       = var.tunnel1_phase1_dh_group_numbers
  tunnel1_phase1_encryption_algorithms  = var.tunnel1_phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms   = var.tunnel1_phase1_integrity_algorithms
  tunnel1_phase2_dh_group_numbers       = var.tunnel1_phase2_dh_group_numbers
  tunnel1_phase2_encryption_algorithms  = var.tunnel1_phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms   = var.tunnel1_phase2_integrity_algorithms

  # Tunnel 2 configuration
  tunnel2_inside_cidr                   = var.tunnel2_inside_cidr
  tunnel2_preshared_key                 = var.tunnel2_preshared_key
  tunnel2_ike_versions                  = var.tunnel2_ike_versions
  tunnel2_phase1_dh_group_numbers       = var.tunnel2_phase1_dh_group_numbers
  tunnel2_phase1_encryption_algorithms  = var.tunnel2_phase1_encryption_algorithms
  tunnel2_phase1_integrity_algorithms   = var.tunnel2_phase1_integrity_algorithms
  tunnel2_phase2_dh_group_numbers       = var.tunnel2_phase2_dh_group_numbers
  tunnel2_phase2_encryption_algorithms  = var.tunnel2_phase2_encryption_algorithms
  tunnel2_phase2_integrity_algorithms   = var.tunnel2_phase2_integrity_algorithms

  create_vpn_gateway_attachment    = true
  connect_to_transit_gateway       = true

  tags = {
    Name = var.aws_vgw_name
  }
}

# Create Transit Gateway Attachment for the VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "dev_qts_vpc_tgw_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.dev_qts_tgw.id
  vpc_id             = aws_vpc.dev_qts_vpc.id
  subnet_ids         = [aws_subnet.dev_qts_subnet.id]

  tags = {
    Name = var.vpc_tgw_attachment_tag
  }
}

# Associate the Transit Gateway Route Table with the VPC
resource "aws_ec2_transit_gateway_route_table_association" "vpn_association" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.dev_qts_vpc_tgw_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_qts_tgw_rt.id
}

# Associate the Transit Gateway Route Table with the VPN
resource "aws_ec2_transit_gateway_route_table_association" "vpc_association" {
  transit_gateway_attachment_id = module.vpn_gateway.vpn_connection_transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_qts_tgw_rt.id
}

# Define a route for the Transit Gateway over the VPN
resource "aws_ec2_transit_gateway_route" "vpn_attachment_route" {
  destination_cidr_block        = var.onprem_cidr_hw_lab
  transit_gateway_attachment_id = module.vpn_gateway.vpn_connection_transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_qts_tgw_rt.id
}

# Define a route for the Transit Gateway over the VPN
resource "aws_ec2_transit_gateway_route" "vpn_attachment_route_2" {
  destination_cidr_block        = var.onprem_cidr_esx_lab
  transit_gateway_attachment_id = module.vpn_gateway.vpn_connection_transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_qts_tgw_rt.id
}

# Define a route for the Transit Gateway over the VPN
resource "aws_ec2_transit_gateway_route" "vpn_attachment_route_3" {
  destination_cidr_block        = var.onprem_cidr_eve_lab
  transit_gateway_attachment_id = module.vpn_gateway.vpn_connection_transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_qts_tgw_rt.id
}

# Define a route for the Transit Gateway over the VPN
resource "aws_ec2_transit_gateway_route" "vpn_attachment_route_4" {
  destination_cidr_block        = var.onprem_cidr_gpvpn
  transit_gateway_attachment_id = module.vpn_gateway.vpn_connection_transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_qts_tgw_rt.id
}

# Define a route for the VPC over the VPN
resource "aws_ec2_transit_gateway_route" "vpn_attachment_route_5" {
  destination_cidr_block        = var.vpc_subnet_cidr_1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.dev_qts_vpc_tgw_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_qts_tgw_rt.id
}

# Define a route for the VPC over the VPN
resource "aws_route" "dev_qts_vpc_route" {
  route_table_id         = aws_vpc.dev_qts_vpc.main_route_table_id
  destination_cidr_block = var.onprem_cidr_hw_lab
  transit_gateway_id     = aws_ec2_transit_gateway.dev_qts_tgw.id
}

# Define a route for the VPC over the VPN
resource "aws_route" "dev_qts_vpc_route_2" {
  route_table_id         = aws_vpc.dev_qts_vpc.main_route_table_id
  destination_cidr_block = var.onprem_cidr_esx_lab
  transit_gateway_id     = aws_ec2_transit_gateway.dev_qts_tgw.id
}

# Define a route for the VPC over the VPN
resource "aws_route" "dev_qts_vpc_route_3" {
  route_table_id         = aws_vpc.dev_qts_vpc.main_route_table_id
  destination_cidr_block = var.onprem_cidr_eve_lab
  transit_gateway_id     = aws_ec2_transit_gateway.dev_qts_tgw.id
}

# Define a route for the VPC over the VPN
resource "aws_route" "dev_qts_vpc_route_4" {
  route_table_id         = aws_vpc.dev_qts_vpc.main_route_table_id
  destination_cidr_block = var.onprem_cidr_gpvpn
  transit_gateway_id     = aws_ec2_transit_gateway.dev_qts_tgw.id
}
