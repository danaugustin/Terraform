#General settings
region               = "us-west-1"
region_az            = "us-west-1a"
bgp_asn              = 65000
cgw_ip_address       = "#.#.#.#"
aws_cgw_name         = "AWS-QTS-CGW"
aws_vgw_name         = "AWS-QTS-VGW"
aws_vpc_name         = "Shared-Prod-Dev-QTS-VPC"
aws_subnet_name      = "dev-build-test-us-west-1a"
aws_network_acl_name = "Dev-QTS-VPC-ACL"
aws_tgw_name         = "AWS-QTS-TGW"
tgw_rt_name             = "AWS-QTS-TGW-RT"
vpc_tgw_attachment_tag  = "AWS-QTS-VPC-TGW-Att"

#CIDR Definitions
onprem_cidr_hw_lab   = "10.150.0.0/16"
onprem_cidr_esx_lab  = "10.1.0.0/16"
onprem_cidr_eve_lab  = "10.3.0.0/16"
onprem_cidr_gpvpn    = "172.16.0.0/24"
vpc_subnet_cidr_1    = "10.50.192.0/20"
vpc_cidr_block       = "10.50.0.0/16"

# Tunnel 1 values
tunnel1_inside_cidr                  = "169.254.10.0/30"
tunnel1_preshared_key                = "###"
tunnel1_ike_versions                 = ["ikev2"]
tunnel1_phase1_dh_group_numbers      = ["20"]
tunnel1_phase1_encryption_algorithms = ["AES256"]
tunnel1_phase1_integrity_algorithms  = ["SHA2-512"]
tunnel1_phase2_dh_group_numbers      = ["20"]
tunnel1_phase2_encryption_algorithms = ["AES256"]
tunnel1_phase2_integrity_algorithms  = ["SHA2-512"]

# Tunnel 2 values
tunnel2_inside_cidr                  = "169.254.11.0/30"
tunnel2_preshared_key                = "###"
tunnel2_ike_versions                 = ["ikev2"]
tunnel2_phase1_dh_group_numbers      = ["20"]
tunnel2_phase1_encryption_algorithms = ["AES256"]
tunnel2_phase1_integrity_algorithms  = ["SHA2-512"]
tunnel2_phase2_dh_group_numbers      = ["20"]
tunnel2_phase2_encryption_algorithms = ["AES256"]
tunnel2_phase2_integrity_algorithms  = ["SHA2-512"]