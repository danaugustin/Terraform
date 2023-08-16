variable "region" {
  description = "AWS region"
  type        = string
}

variable "region_az" {
  description = "AWS Availability Zone region"
  type        = string
}

variable "bgp_asn" {
  description = "BGP ASN for Customer Gateway"
  type        = number
}

variable "cgw_ip_address" {
  description = "IP address of Customer Gateway"
  type        = string
}

variable "aws_cgw_name" {
  description = "Name of the Customer Gateway"
  type        = string
}

variable "aws_vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "aws_subnet_name" {
  description = "Name of the VPC Subnet"
  type        = string
}

variable "aws_tgw_name" {
  description = "Name of the Transit Gateway"
  type        = string
}

variable "aws_network_acl_name" {
  description = "Name of the ACL"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "tgw_rt_name" {
  description = "Transit Gateway Routing Table name"
  type        = string
}

variable "aws_vgw_name" {
  description = "VPN Gateway name"
  type        = string
}

# Tunnel 1 variables
variable "tunnel1_inside_cidr" {
  description = "CIDR block for Tunnel 1 inside address range"
}

variable "tunnel1_preshared_key" {
  description = "Preshared key for Tunnel 1"
}

variable "tunnel1_ike_versions" {
  description = "IKE versions for Tunnel 1"
  type        = list(string)
}

variable "tunnel1_phase1_dh_group_numbers" {
  description = "Diffie-Hellman group numbers for Tunnel 1 Phase 1"
  type        = list(string)
}

variable "tunnel1_phase1_encryption_algorithms" {
  description = "Encryption algorithms for Tunnel 1 Phase 1"
  type        = list(string)
}

variable "tunnel1_phase1_integrity_algorithms" {
  description = "Integrity algorithms for Tunnel 1 Phase 1"
  type        = list(string)
}

variable "tunnel1_phase2_dh_group_numbers" {
  description = "Diffie-Hellman group numbers for Tunnel 1 Phase 2"
  type        = list(string)
}

variable "tunnel1_phase2_encryption_algorithms" {
  description = "Encryption algorithms for Tunnel 1 Phase 2"
  type        = list(string)
}

variable "tunnel1_phase2_integrity_algorithms" {
  description = "Integrity algorithms for Tunnel 1 Phase 2"
  type        = list(string)
}

# Tunnel 2 variables
variable "tunnel2_inside_cidr" {
  description = "CIDR block for Tunnel 2 inside address range"
}

variable "tunnel2_preshared_key" {
  description = "Preshared key for Tunnel 2"
}

variable "tunnel2_ike_versions" {
  description = "IKE versions for Tunnel 2"
  type        = list(string)
}

variable "tunnel2_phase1_dh_group_numbers" {
  description = "Diffie-Hellman group numbers for Tunnel 2 Phase 1"
  type        = list(string)
}

variable "tunnel2_phase1_encryption_algorithms" {
  description = "Encryption algorithms for Tunnel 2 Phase 1"
  type        = list(string)
}

variable "tunnel2_phase1_integrity_algorithms" {
  description = "Integrity algorithms for Tunnel 2 Phase 1"
  type        = list(string)
}

variable "tunnel2_phase2_dh_group_numbers" {
  description = "Diffie-Hellman group numbers for Tunnel 2 Phase 2"
  type        = list(string)
}

variable "tunnel2_phase2_encryption_algorithms" {
  description = "Encryption algorithms for Tunnel 2 Phase 2"
  type        = list(string)
}

variable "tunnel2_phase2_integrity_algorithms" {
  description = "Integrity algorithms for Tunnel 2 Phase 2"
  type        = list(string)
}

variable "vpc_tgw_attachment_tag" {
  description = "Tag for the VPC Transit Gateway Attachment"
  type        = string
}

variable "onprem_cidr_hw_lab" {
  description = "CIDR block for the hardware lab"
  type        = string
}

variable "onprem_cidr_esx_lab" {
  description = "CIDR block for the ESX lab"
  type        = string
}

variable "onprem_cidr_eve_lab" {
  description = "CIDR block for the Eve lab"
  type        = string
}

variable "onprem_cidr_gpvpn" {
  description = "CIDR block for the HQ network"
  type        = string
}

variable "vpc_subnet_cidr_1" {
  description = "CIDR block for the AWS subnet"
  type        = string
}