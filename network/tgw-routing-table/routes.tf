resource "aws_ec2_transit_gateway_route" "this" {
  count                           = length(var.routes)
  transit_gateway_route_table_id  = var.transit_gateway_route_table_id
  transit_gateway_attachment_id   = var.routes[count.index].transit_gateway_attachment_id
  destination_cidr_block          = var.routes[count.index].destination_cidr_block
  blackhole                       = var.routes[count.index].blackhole
}