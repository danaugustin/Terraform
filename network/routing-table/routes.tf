resource "aws_route" "this" {
  count                       = length(var.routes)
  route_table_id              = var.route_table_id
  destination_cidr_block      = var.routes[count.index].destination_cidr_block
  gateway_id                  = var.routes[count.index].gateway_id
  nat_gateway_id              = var.routes[count.index].nat_gateway_id
  network_interface_id        = var.routes[count.index].network_interface_id
  transit_gateway_id          = var.routes[count.index].transit_gateway_id
  vpc_peering_connection_id   = var.routes[count.index].vpc_peering_connection_id
  egress_only_gateway_id      = var.routes[count.index].egress_only_gateway_id
  local_gateway_id            = var.routes[count.index].local_gateway_id
  carrier_gateway_id          = var.routes[count.index].carrier_gateway_id
}