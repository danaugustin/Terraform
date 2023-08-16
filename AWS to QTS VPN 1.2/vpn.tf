locals {
  outbound_rules = {
    100 = var.vpc_subnet_cidr_1,
    101 = var.onprem_cidr_hw_lab,
    102 = var.onprem_cidr_esx_lab,
    103 = var.onprem_cidr_eve_lab,
    104 = var.onprem_cidr_gpvpn
  }
  
  inbound_rules = {
    200 = var.onprem_cidr_hw_lab,
    201 = var.onprem_cidr_esx_lab,
    202 = var.onprem_cidr_eve_lab,
    203 = var.vpc_subnet_cidr_1,
    204 = var.onprem_cidr_gpvpn
  }

  transit_gateway_routes = {
    hw_lab = var.onprem_cidr_hw_lab,
    esx_lab = var.onprem_cidr_esx_lab,
    eve_lab = var.onprem_cidr_eve_lab,
    gpvpn   = var.onprem_cidr_gpvpn,
    vpc_subnet = var.vpc_subnet_cidr_1
  }

  vpc_routes = {
    hw_lab = var.onprem_cidr_hw_lab,
    esx_lab = var.onprem_cidr_esx_lab,
    eve_lab = var.onprem_cidr_eve_lab,
    gpvpn   = var.onprem_cidr_gpvpn
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  name = var.aws_vpc_name
  cidr = var.vpc_cidr_block
  default_vpc_enable_dns_hostnames = true
  default_vpc_enable_dns_support = true
  tags = {
    Name = var.aws_vpc_name
  }
}

resource "aws_customer_gateway" "dev_qts_cgw" {
  bgp_asn    = var.bgp_asn
  ip_address = var.cgw_ip_address
  type       = "ipsec.1"
  tags = {
    Name = var.aws_cgw_name
  }
}


#Create an ACL to manage traffic in the VPC
resource "aws_network_acl" "dev_qts_vpc_acl" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = var.aws_network_acl_name
  }
}

#Loop to create outbound rules for each CIDR defined in outbound_rules
resource "aws_network_acl_rule" "outbound_rule" {
  for_each       = local.outbound_rules
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = each.key
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = each.value
}

#Loop to create inbound rules for each CIDR defined in outbound_rules
resource "aws_network_acl_rule" "inbound_rule" {
  for_each       = local.inbound_rules
  network_acl_id = aws_network_acl.dev_qts_vpc_acl.id
  rule_number    = each.key
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = each.value
}

# Create the subnet to be used for Dev internal
resource "aws_subnet" "dev_qts_subnet" {
  vpc_id                  = module.vpc.vpc_id
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

  vpc_id = module.vpc.vpc_id

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
  vpc_id             = module.vpc.vpc_id
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

# Define routes for the Transit Gateway over the VPN. This will loop over the transit_gateway_routes map and for each key the value will be used to fill in the destination_cidr_block. The transit_gateway_attachment_id
# is based on the key found in the trans_gateway_routes map. If the key is vpc_subnet, then use aws_ec2_transit_gateway_vpc_attachment.dev_qts_vpc_tgw_attachment.id , otherwise use module.vpn_gateway.vpn_connection_transit_gateway_attachment_id
  resource "aws_ec2_transit_gateway_route" "vpn_attachment_routes" {
  for_each                        = local.transit_gateway_routes
  destination_cidr_block          = each.value
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.dev_qts_tgw_rt.id

  transit_gateway_attachment_id   = each.key == "vpc_subnet" 
                                    ? aws_ec2_transit_gateway_vpc_attachment.dev_qts_vpc_tgw_attachment.id 
                                    : module.vpn_gateway.vpn_connection_transit_gateway_attachment_id
}

# Define routes for the VPC over the VPN. This will loop over the vpc_routes map and for each key the value will be used to fill in the destination_cidr_block
resource "aws_route" "dev_qts_vpc_routes" {
  for_each               = local.vpc_routes
  route_table_id         = aws_vpc.dev_qts_vpc.main_route_table_id
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.dev_qts_tgw.id
}

