variable "region" {
  description = "AWS region"
  type        = string
}

variable "transit_gateway_id" {
  description = "The ID of the Transit Gateway to attach the VPN to"
  type        = string
}

variable "customer_gateway_ip" {
  description = "The IP address of the customer gateway"
  type        = string
}

variable "customer_gateway_bgp_asn" {
  description = "The BGP ASN of the customer gateway"
  type        = number
}

variable "static_routes_only" {
  description = "Whether or not to use static routes"
  default     = false
}

variable "transit_gateway_route_table_id" {
  description = "The ID of the route table to add routes to."
  type        = string
}

variable "routes" {
  description = "List of routes to add to the route table."
  type = list(object({
    destination_cidr_block         = string
    transit_gateway_attachment_id  = optional(string)
  }))
  default = []
}

variable "vpn_tunnel_inside_cidr" {
  description = "The CIDR block for the VPN tunnel inside address"
  type        = string
  default     = "169.254.12.0/30"
}

# Tunnel 1 variables
variable "tunnel1_inside_cidr" {
  description = "CIDR block for Tunnel 1 inside address range"
  type        = string
}

variable "tunnel1_preshared_key" {
  description = "Preshared key for Tunnel 1"
  type        = string
}

variable "tunnel1_ike_versions" {
  description = "IKE versions"
  type        = list(string)
}

variable "tunnel1_phase1_dh_group_numbers" {
  description = "Diffie-Hellman group numbers for Phase 1"
  type        = list(string)
}

variable "tunnel1_dpd_timeout_action" {
  description = "Dead Peer Detection action"
  type        = string
}

variable "tunnel1_dpd_timeout_seconds" {
  description = "Dead Peer Detection timeout"
  type        = number
}

variable "tunnel1_phase1_encryption_algorithms" {
  description = "Encryption algorithms for Phase 1"
  type        = list(string)
}

variable "tunnel1_phase1_integrity_algorithms" {
  description = "Integrity algorithms for Phase 1"
  type        = list(string)
}

variable "tunnel1_phase1_lifetime_seconds" {
  description = "Lifetime in seconds for Phase 1"
  type        = number
}

variable "tunnel1_phase2_dh_group_numbers" {
  description = "Diffie-Hellman group numbers for Phase 2"
  type        = list(string)
}

variable "tunnel1_phase2_encryption_algorithms" {
  description = "Encryption algorithms for Phase 2"
  type        = list(string)
}

variable "tunnel1_phase2_integrity_algorithms" {
  description = "Integrity algorithms for Phase 2"
  type        = list(string)
}

variable "tunnel1_phase2_lifetime_seconds" {
  description = "Lifetime in seconds for Phase 2"
  type        = number
}

variable "tunnel1_replay_window_size" {
  description = "Replay Window Size"
  type        = number
}

variable "tunnel1_startup_action" {
  description = "Tunnel startup action"
  type        = string
}

#Tunnel 2 variables
variable "tunnel2_inside_cidr" {
  description = "CIDR block for Tunnel 2 inside address range"
  type        = string
}

variable "tunnel2_preshared_key" {
  description = "Preshared key for Tunnel 2"
  type        = string
}
variable "tunnel2_ike_versions" {
  description = "IKE versions"
  type        = list(string)
}

variable "tunnel2_phase1_dh_group_numbers" {
  description = "Diffie-Hellman group numbers for Phase 1"
  type        = list(string)
}

variable "tunnel2_dpd_timeout_action" {
  description = "Dead Peer Detection action"
  type        = string
}

variable "tunnel2_dpd_timeout_seconds" {
  description = "Dead Peer Detection timeout"
  type        = number
}

variable "tunnel2_phase1_encryption_algorithms" {
  description = "Encryption algorithms for Phase 1"
  type        = list(string)
}

variable "tunnel2_phase1_integrity_algorithms" {
  description = "Integrity algorithms for Phase 1"
  type        = list(string)
}

variable "tunnel2_phase1_lifetime_seconds" {
  description = "Lifetime in seconds for Phase 1"
  type        = number
}

variable "tunnel2_phase2_dh_group_numbers" {
  description = "Diffie-Hellman group numbers for Phase 2"
  type        = list(string)
}

variable "tunnel2_phase2_encryption_algorithms" {
  description = "Encryption algorithms for Phase 2"
  type        = list(string)
}

variable "tunnel2_phase2_integrity_algorithms" {
  description = "Integrity algorithms for Phase 2"
  type        = list(string)
}

variable "tunnel2_phase2_lifetime_seconds" {
  description = "Lifetime in seconds for Phase 2"
  type        = number
}

variable "tunnel2_replay_window_size" {
  description = "Replay Window Size"
  type        = number
}

variable "tunnel2_startup_action" {
  description = "Tunnel startup action"
  type        = string
}

variable "vpn_name" {
  description = "VPN name"
  type        = string
}