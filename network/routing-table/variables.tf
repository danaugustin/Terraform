variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-west-2"
}

variable "route_table_id" {
  description = "The ID of the route table to add routes to."
  type        = string
}

variable "routes" {
  description = "List of routes to add to the route table."
  type = list(object({
    destination_cidr_block    = string
    gateway_id                = optional(string)
    nat_gateway_id            = optional(string)
    network_interface_id      = optional(string)
    transit_gateway_id        = optional(string)
    vpc_peering_connection_id = optional(string)
    egress_only_gateway_id    = optional(string)
    local_gateway_id          = optional(string)
    carrier_gateway_id        = optional(string)
  }))
  default = []
}