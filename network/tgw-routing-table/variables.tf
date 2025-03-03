variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-west-2"
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
    blackhole                      = optional(bool)
  }))
  default = []
}